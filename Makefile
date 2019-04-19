.PHONY: version build build_linux docker_login docker_build docker_push_dev docker_push_pro
.PHONY: rm_stop

_Version = $(shell git tag --sort=committerdate | tee | tail -n 1)
_VersionFile = version/version.go
_VersionCheckFile = version/version.md
_CommitVersion = $(shell git rev-parse --short=8 HEAD)
_BuildVersion = $(shell date "+%F %T")
_GOBIN = $(shell pwd)

_ImageName = kmqproxy
_ProjectPath = $(_ImageName)
_ImagesPrefix = registry.cn-hangzhou.aliyuncs.com/ybase/
_ImageLatestName = $(_ImagesPrefix)$(_ImageName)
_ImageTestName = $(_ImagesPrefix)$(_ImageName):test
_ImageVersionName = $(_ImagesPrefix)$(_ImageName):$(_Version)

version:_version
	@echo $(_Version)

_version:

ifeq ($(_Version), $(shell cat version/version | head -n 1))
		@git tag -n --sort=committerdate | tee | tail -n 5
		exit "项目版本没有变动"
endif

	@echo "package version" > $(_VersionFile)
	@echo "const Version = "\"$(_Version)\" >> $(_VersionFile)
	@echo "const BuildVersion = "\"$(_BuildVersion)\" >> $(_VersionFile)
	@echo "const CommitVersion = "\"$(_CommitVersion)\" >> $(_VersionFile)

	@echo "## Version: $(_Version)" >> $(_VersionCheckFile)
	@echo "	1. BuildVersion: $(_BuildVersion)" >> $(_VersionCheckFile)
	@echo "	2. CommitVersion: $(_CommitVersion)" >> $(_VersionCheckFile)
	@echo "	3. CommitMsg: $(shell git log -1 | tail -n 1)" >> $(_VersionCheckFile)

b:
	@echo "开始编译"
	GOBIN=$(_GOBIN) go install main.go

r:
	@echo "开始执行"
	go run main.go

_build_linux: _version
	@echo "交叉编译成linux应用"
	docker run --rm -v $(GOPATH):/go golang:latest go build -o /go/src/$(_ProjectPath)/main /go/src/$(_ProjectPath)/main.go

rm_stop:
	@echo "删除所有的的容器"
	sudo docker rm -f $(sudo docker ps -qa)
	sudo docker ps -a

rm_image:
	@echo "删除所为none的image"
	sudo docker images  | grep %(_ImageName) | awk '{print $3}' | xargs docker rmi -f

rm_none:
	@echo "删除所为none的image"
	sudo docker images  | grep none | awk '{print $3}' | xargs docker rmi -f

docker:_build_linux
	@echo "docker build and push"
	sudo docker build -t $(_ImageVersionName) .
	sudo docker push $(_ImageVersionName)
	@echo "$(_Version)" > "version/version"

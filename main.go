package main

import (
	"github.com/kooksee/kmqproxy/cmds"
	"github.com/kooksee/kmqproxy/internal/cnst"

	"github.com/pubgo/assert"
	"github.com/pubgo/gocmds"
	"os"
)

func main() {
	rootCmd := cmds.RootCmd
	rootCmd.AddCommand(
		cmds.InitFilesCmd,
		cmds.VersionCmd,
		cmds.ServerCmd,
	)

	assert.MustNotError(gocmds.PrepareBaseCmd(rootCmd, cnst.EnvPrefix,
		os.ExpandEnv(cnst.CurPath)).Execute())
}

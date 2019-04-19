package main

import (
	"github.com/kooksee/kmqproxy/cmds"
	"github.com/kooksee/kmqproxy/internal/cnst"
	"github.com/kooksee/kmqproxy/internal/g"
	"os"
)

func main() {
	rootCmd := cmds.RootCmd
	rootCmd.AddCommand(
		cmds.InitFilesCmd,
		cmds.VersionCmd,
		cmds.ServerCmd,
		cmds.AgentCmd,
	)
	g.MustNotError(g.PrepareBaseCmd(rootCmd, cnst.EnvPrefix, os.ExpandEnv(cnst.CurPath)).Execute())
}

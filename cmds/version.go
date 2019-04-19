package cmds

import (
	"fmt"
	"github.com/kooksee/kmqproxy/version"
	"github.com/spf13/cobra"
)

var VersionCmd = &cobra.Command{
	Use:     "version",
	Aliases: []string{"v"},
	Short:   "Show Version Info",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Version", version.Version)
		fmt.Println("Commit version", version.CommitVersion)
		fmt.Println("Build version", version.BuildVersion)
	},
}

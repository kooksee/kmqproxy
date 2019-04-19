package cmds

import (
	"github.com/spf13/cobra"
)

var AgentCmd = &cobra.Command{
	Use:     "agent",
	Aliases: []string{"ag"},
	Short:   "node agent",
	Run: func(cmd *cobra.Command, args []string) {
	},
}

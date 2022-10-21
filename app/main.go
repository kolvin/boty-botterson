package main

import (
	"flag"
	"fmt"
	"os"
	"os/signal"
	"syscall"

	"github.com/bwmarrin/discordgo"
)

// Variables used for command line parameters
var (
	Token string
)

func init() {

	flag.StringVar(&Token, "t", "", "Bot Token")
	flag.Parse()
}

func main() {

	testingChannel := "964268040780918824"

	// Create a new Discord session using the provided bot token.
	discordSession, err := discordgo.New("Bot " + Token)
	if err != nil {
		fmt.Println("error creating Discord session,", err)
		return
	}

	// Register the messageCreate func as a callback for MessageCreate events.
	discordSession.AddHandler(messageCreate)

	// https://discordjs.guide/popular-topics/intents.html#gateway-intents
	// Discord permissions
	discordSession.Identify.Intents |= discordgo.IntentMessageContent

	// Open a websocket connection to Discord and begin listening.
	err = discordSession.Open()
	if err != nil {
		fmt.Println("error opening connection,", err)
		return
	}

	// Wait here until CTRL-C or other term signal is received.
	fmt.Println("Boty Botterson has initialized...")
	fmt.Println("Press CTRL-C to exit.")
	discordSession.ChannelMessageSend(testingChannel, "Boty Botterson has initialized... 🤖")
	sc := make(chan os.Signal, 1)
	signal.Notify(sc, syscall.SIGINT, syscall.SIGTERM, os.Interrupt, os.Kill)
	<-sc

	discordSession.ChannelMessageSend(testingChannel, "Boty Botterson has shutdown... 👋🏻")
	// Cleanly close down the Discord session.
	discordSession.Close()
}

func messageCreate(s *discordgo.Session, m *discordgo.MessageCreate) {
	// If the message is "ping" reply with "Pong!"
	if m.Content == "!ping" {
		s.ChannelMessageSend(m.ChannelID, "pong!")
	}

	// If the message is "pong" reply with "Ping!"
	if m.Content == "!pong" {
		s.ChannelMessageSend(m.ChannelID, "ping!")
	}
}

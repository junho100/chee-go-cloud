package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/bwmarrin/discordgo"
)

type CloudWatchAlarmMessage struct {
	AlarmName      string `json:"AlarmName"`
	NewStateValue  string `json:"NewStateValue"`
	NewStateReason string `json:"NewStateReason"`
}

func handleRequest(ctx context.Context, snsEvent events.SNSEvent) error {
	discord, err := discordgo.New("Bot " + os.Getenv("DISCORD_BOT_TOKEN"))
	if err != nil {
		return fmt.Errorf("creating Discord session: %v", err)
	}
	defer discord.Close()

	var alarmMessage CloudWatchAlarmMessage
	if err := json.Unmarshal([]byte(snsEvent.Records[0].SNS.Message), &alarmMessage); err != nil {
		return fmt.Errorf("parsing SNS message: %v", err)
	}

	message := fmt.Sprintf("🚨 EC2 Status Alert\n"+
		"Alarm: %s\n"+
		"Status: %s\n"+
		"Reason: %s",
		alarmMessage.AlarmName,
		alarmMessage.NewStateValue,
		alarmMessage.NewStateReason)

	channel, err := discord.UserChannelCreate(os.Getenv("DISCORD_USER_ID"))
	if err != nil {
		return fmt.Errorf("creating DM channel: %v", err)
	}

	_, err = discord.ChannelMessageSend(channel.ID, message)
	if err != nil {
		return fmt.Errorf("sending Discord message: %v", err)
	}

	log.Printf("Alert sent successfully: %s", alarmMessage.AlarmName)
	return nil
}

func main() {
	lambda.Start(handleRequest)
}

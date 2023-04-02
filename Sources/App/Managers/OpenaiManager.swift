//
//  OpenaiManager.swift
//  
//
//  Created by Mike on 4/2/23.
//

import AsyncHTTPClient
import Foundation
import OpenAIKit

class OpenAIManager {
    private let openAIClient: OpenAIKit.Client
    private let httpClient: HTTPClient
    
    init(apiKey: String, organization: String) {
        httpClient = HTTPClient(eventLoopGroupProvider: .createNew)
        let configuration = Configuration(apiKey: apiKey, organization: organization)
        self.openAIClient = OpenAIKit.Client(httpClient: httpClient, configuration: configuration)
    }
    
    deinit {
        try? httpClient.syncShutdown()
    }
    
    func generatePrompt(prompt: String) async throws -> String {
        let response = try await openAIClient.completions.create(
            model: Model.GPT3.textDavinci003,
            prompts: ["JuC is a chatbot that reluctantly answers questions with sarcastic responses:\n\nYou: Hi\nJuC: This again? What do you want.\nYou: I need an email?\nJuC: You can't type? Ok, what are you needing to say?\nYou: Im taking next week off, is there anything you need before?\nJuC: Fine, your looking for something like this \nDear [Name],\n\nI am writing to inform you that I will be taking the week off starting [date]. I understand that this may cause some disruption, but I am confident that any tasks I have can be delegated to other members of the team. \n\nIf there is anything you need from me before I take my leave, please let me know and I will do my best to accommodate.\n\nThank you for your understanding.\n\nSincerely,\n[Your Name]\n" + prompt],
            maxTokens: 1250,
            temperature: 1,
            topP: 1,
            presencePenalty: 0.4,
            frequencyPenalty: 0.4
        )
        let result = response.choices[0].text
        return result
    }
    
    func startChat(msg: [Chat.Message]) async throws -> Chat.Message? {
        var messages: [Chat.Message] = [.system(content: "You are JuC an insanely sarcastic assistant that is mean, while helping users write professional messages, emails, or professional text for work. \n DO Not answer anything that isn't related to professional communications, If the user asks anything not related to professional communications give a sarcastic and mean response to steer the conversation back on topic.")]
        messages.append(contentsOf: msg)
        let response = try await openAIClient.chats.create(model: Model.GPT3.gpt3_5Turbo0301, messages: messages, temperature: 1.0, topP: 1.0, maxTokens: 550, presencePenalty: 0.18, frequencyPenalty: 0.26)
        return response.choices.first?.message
    }
}

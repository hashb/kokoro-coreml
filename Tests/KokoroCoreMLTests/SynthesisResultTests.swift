import Foundation
import Testing

@testable import KokoroCoreML

@Suite("SynthesisResult")
struct SynthesisResultTests {
    @Test("Timestamps are exposed on synthesis results")
    func timestampsAPI() {
        let timestamp = SynthesisTimestamp(
            text: "hello",
            phonemes: "həlˈO",
            startTime: 0.0,
            endTime: 0.42)
        let result = SynthesisResult(
            samples: [],
            phonemes: "həlˈO",
            timestamps: [timestamp],
            tokenCount: 7,
            synthesisTime: 0.1)

        #expect(result.timestamps == [timestamp])
        #expect(result.timestamps[0].duration == 0.42)
    }

    @Test("Text synthesis includes timestamps when local models are available")
    func synthesisTimestampsWhenModelsAvailable() throws {
        let modelDirectory = ModelManager.defaultDirectory(for: "kokoro-coreml")
        guard KokoroEngine.isDownloaded(at: modelDirectory) else { return }

        let engine = try KokoroEngine(modelDirectory: modelDirectory)
        let result = try engine.synthesize(text: "hello world", voice: "af_heart")

        #expect(result.timestamps.map(\.text).contains("hello"))
        #expect(result.timestamps.map(\.text).contains("world"))
        #expect(result.timestamps.allSatisfy { $0.startTime >= 0 && $0.endTime <= result.duration })
    }
}

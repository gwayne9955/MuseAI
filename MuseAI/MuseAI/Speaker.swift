//
//  Speaker.swift
//  MuseAI
//
//  Created by Garrett Wayne on 2/7/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import Foundation
import AudioToolbox

class Speaker {
    
    var audioGraph: AUGraph? // used to process audio units traveling through the audio graph
    var synthNode = AUNode() // the midi synth
    var outputNode = AUNode() // the node processing input to output
    var synthUnit: AudioUnit?
    var patch = UInt32(0) // the piano sound font
    
    func initAudio() { // helps us manage all of our audio and load other functions
        checkError(osstatus: NewAUGraph(&audioGraph))
        createOutputNode()
        createSynthNode()
        checkError(osstatus: AUGraphOpen(audioGraph!))
        checkError(osstatus: AUGraphNodeInfo(audioGraph!, synthNode, nil, &synthUnit))
        let synthOutputElement: AudioUnitElement = 0
        let ioInputElement: AudioUnitElement = 0 // devices like microphones would be 1
        checkError(osstatus: AUGraphConnectNodeInput(
            audioGraph!,
            synthNode,
            synthOutputElement,
            outputNode,
            ioInputElement)) // connecting all of the synth unit to the speakers (aka 0)
        checkError(osstatus: AUGraphInitialize(audioGraph!))
        checkError(osstatus: AUGraphStart(audioGraph!))
        loadSoundFont()
        loadPatch(patchNo: 0)
    }
    
    func createOutputNode() { // connects the node directly to the device speakers for processing of audio
        var componentDescription = AudioComponentDescription(
            componentType: OSType(kAudioUnitType_Output),
            componentSubType: OSType(kAudioUnitSubType_RemoteIO),
            componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
            componentFlags: 0,
            componentFlagsMask: 0)
        checkError(osstatus: AUGraphAddNode(audioGraph!, &componentDescription, &outputNode))
    }
    
    func createSynthNode() { // store the audio unit for the synthesizer
        var componentDescription = AudioComponentDescription(
            componentType: OSType(kAudioUnitType_MusicDevice),
            componentSubType: OSType(kAudioUnitSubType_MIDISynth),
            componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
            componentFlags: 0,
            componentFlagsMask: 0)
        checkError(osstatus: AUGraphAddNode(audioGraph!, &componentDescription, &synthNode))
    }
    
    func loadSoundFont() {
        var bankURL = Bundle.main.url(forResource: "FluidR3_GM", withExtension: "sf2")
        checkError(osstatus: AudioUnitSetProperty(synthUnit!, AudioUnitPropertyID(kMusicDeviceProperty_SoundBankURL), AudioUnitScope(kAudioUnitScope_Global), 0, &bankURL, UInt32(MemoryLayout<URL>.size))) // setting our synth audio unit's property to our sound bank
    }
    
    func loadPatch(patchNo: Int) {
        let channel = UInt32(0)
        var enabled = UInt32(1)
        var disabled = UInt32(0)
        patch = UInt32(patchNo)
        checkError(osstatus: AudioUnitSetProperty(
            synthUnit!,
            AudioUnitPropertyID(kAUMIDISynthProperty_EnablePreload),
            AudioUnitScope(kAudioUnitScope_Global),
            0, &enabled,
            UInt32(MemoryLayout<URL>.size)))
        
        let programChangeCommand = UInt32(0xC0 | channel)
        checkError(osstatus: MusicDeviceMIDIEvent(
            self.synthUnit!,
            programChangeCommand,
            patch, 0, 0))
        
        checkError(osstatus: AudioUnitSetProperty(
            synthUnit!,
            AudioUnitPropertyID(kAUMIDISynthProperty_EnablePreload),
            AudioUnitScope(kAudioUnitScope_Global),
            0, &disabled,
            UInt32(MemoryLayout<URL>.size)))
        
        checkError(osstatus: MusicDeviceMIDIEvent(
            self.synthUnit!,
            programChangeCommand,
            patch, 0, 0))
    }
    
    func checkError(osstatus: OSStatus) {
        if osstatus != noErr {
            print(SoundError.GetErrorMessage(osstatus))
        }
    }
    
}

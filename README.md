# ReEnabled

<img width="256" alt="ReEnabled Logo 2 (original)" src="https://github.com/user-attachments/assets/737847d1-d58d-491d-84f5-fdb97ec51a64">

## Table of Content
* [General Info](#general-info)
* [Technologies](#technologies)
* [Status](#status)
* [Requirements](#requirements)
* [Functionalities](#functionalities)
* [Screenshots](#screenshots)
* [Preview Video](#preview)


## General info
The developed application is an innovative solution aimed at assisting visually impaired users in navigating their daily tasks through a combination of advanced technologies, including Artificial Intelligence (AI), voice commands, and gesture-based controls. The primary focus of the app is to enhance accessibility for blind or visually impaired individuals by providing real-time object recognition, text scanning, safe navigation features and OpenAI functionalities.


## Technologies
* Swift [SwiftUI + UIKit]    
* Xcode 15
* [Apple ML](https://developer.apple.com/machine-learning/)
* [Apple VisionKit](https://developer.apple.com/documentation/visionkit)
* [MongoDB Realm](https://www.mongodb.com/docs/atlas/device-sdks/sdk/swift/)
* [Accessibility features](https://developer.apple.com/accessibility/)
* [OpenAI API](https://platform.openai.com/docs/overview)
* [Ampel-Pilot-iOS](https://github.com/strator1/Ampel-Pilot-iOS)
* [YOLOv3](https://github.com/MPieter/YOLO-CoreML/tree/master)
* [Lottie](https://lottiefiles.com/)
* [Swinject](https://github.com/Swinject/Swinject)
* Text-to-speech (TTS) and Speech-to-text (STT)


## Status
Finished


## Requirements
Apple iPhone with iOS 15+ installed


## Functionalities
* Pedestrian crossing light color indicator: Identify the color of pedestrian crossing's light to provide user with real-time navigation suggestions. Powered by [Ampel-Pilot-iOS](https://github.com/strator1/Ampel-Pilot-iOS)
* Real-time Object Recognition: By using the device’s camera, the application identifies objects and obstacles in real-time, ensuring users can avoid hazards during movement. It also alerts the user through vibrations and sound signals. Powered by [YOLOv3](https://github.com/MPieter/YOLO-CoreML/tree/master)
* Text Scanning and Voice Feedback: The app allows scanning of textual documents or product labels and reads the content aloud using text-to-speech (TTS) technology.
* Color identification: Use the camera to identify color of dominant object in the area or measure
* Light intensity measures: Use the camera to measure light intensity and notify the user by playing the sound which volume increases as light intensity level increases
* AI-Powered OpenAI Interaction: The integration of AI models (such as GPT) enables the app to handle complex queries and provide dynamic responses, offering assistance to users by answering their question or analyzing photos.
* Gesture and Voice Commands: To ensure ease of use, the app supports various custom touch gestures (e.g., tap, swipe) and voice commands (speech-to-text STT technology), enabling users to perform tasks hands-free, reducing the need for tactile input.
* Customizable Interface: Users can adjust the app’s speech speed, voice, and even the interface language to suit their individual preferences.
* App Guide: Get to know about all the app's functionalities by completing the onboarding which teaches the user how to use the app


## Screenshots

### CameraTab

<p float="left">
  <img src="https://github.com/user-attachments/assets/4deceb99-ecce-46f5-94fa-12d552125f56" width="40%" />
  <img src="https://github.com/user-attachments/assets/c66f912a-c813-4185-8e4a-976d1c241709" width="20%" />
  <img src="https://github.com/user-attachments/assets/7cf50fa5-f4a1-4f7f-adba-a5f87a1b7317" width="20%" />
  <img src="https://github.com/user-attachments/assets/5d315944-b1fc-421e-bb0c-ee9f1209ba62" width="20%" />
</p>


### ChatTab

<p float="left">
  <img src="https://github.com/user-attachments/assets/a81b7389-e32d-46e0-9a52-9dfae9e865c9" width="60%" />
</p>


### SettingsTab

<p float="left">
  <img src="https://github.com/user-attachments/assets/d79f478d-1698-46c5-b7a2-45b3502f9601" width="20%" />
  <img src="https://github.com/user-attachments/assets/31ed89e5-4e0b-43bd-a702-0c7fec960025" width="20%" />
  <img src="https://github.com/user-attachments/assets/ee02ce74-b611-4e9c-baea-241d3ffd6f0c" width="20%" />
</p>


### Onboarding

<p float="left">
  <img src="https://github.com/user-attachments/assets/3c54f3ce-7eac-4534-b993-444f0b6deba3" width="60%" />
</p>


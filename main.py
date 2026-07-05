"""
Hand Tracking Computer Vision Application
==========================================
Real-time hand detection and tracking using OpenCV and MediaPipe

Features:
- Real-time hand detection
- Finger landmark identification
- Finger counting
- Hand movement tracking
- Gesture recognition

Author: Computer Vision Project
"""

import cv2
import mediapipe as mp
import numpy as np
from hand_tracker import HandDetector
from finger_counter import FingerCounter
from gesture_controller import GestureController
import utils
import streamlit

# Initialize MediaPipe drawing utilities
mp_drawing = mp.solutions.drawing_utils
mp_hands = mp.solutions.hands

def main():
    """
    Main function to run the hand tracking application
    """
    print("=" * 50)
    print("  Hand Tracking Computer Vision Application")
    print("=" * 50)
    print("\nStarting camera...")
    print("Press 'q' to quit")
    print("Press 'f' to toggle fullscreen")
    print("Press 'm' to toggle mouse control mode")
    print("=" * 50)
    
    # Initialize the hand detector
    detector = HandDetector()
    
    # Initialize finger counter
    finger_counter = FingerCounter()
    
    # Initialize gesture controller
    gesture_controller = GestureController()
    
    # Open the default camera (0 is the default camera)
    cap = cv2.VideoCapture(0)
    
    # Check if camera opened successfully
    if not cap.isOpened():
        print("Error: Could not open camera")
        return
    
    # Set camera resolution
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)
    
    # Get actual dimensions
    width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    print(f"Camera resolution: {width}x{height}")
    
    # FPS calculation variables
    fps = 0
    frame_count = 0
    import time
    start_time = time.time()
    
    # Mouse control mode flag
    mouse_control_mode = False
    
    # Fullscreen flag
    fullscreen = False
    
    # Main loop
    while True:
        # Read frame from camera
        ret, frame = cap.read()
        
        if not ret:
            print("Error: Failed to capture frame")
            break
        
        # Flip the frame horizontally for more natural interaction
        frame = cv2.flip(frame, 1)
        
        # Detect hands
        hands, annotated_frame = detector.detect_hands(frame)
        
        # Process each detected hand
        for hand_idx, hand in enumerate(hands):
            # Count raised fingers
            finger_count = finger_counter.count_fingers(hand)
            
            # Get hand landmarks
            landmarks = hand.landmark
            
            # Get hand position and direction
            hand_position = detector.get_hand_position(hand, frame.shape)
            hand_direction = detector.get_hand_direction(hand)
            
            # Recognize gesture
            gesture = gesture_controller.recognize_gesture(hand, finger_count)
            
            # Display finger count on frame
            x, y = int(landmarks[0].x * frame.shape[1]), int(landmarks[0].y * frame.shape[0])
            
            # Draw finger count
            cv2.rectangle(annotated_frame, (x - 50, y - 60), (x + 80, y - 10), (0, 255, 0), -1)
            cv2.putText(annotated_frame, f"Fingers: {finger_count}", (x - 45, y - 25),
                       cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 0), 2)
            
            # Draw gesture label
            cv2.putText(annotated_frame, f"Gesture: {gesture}", (10, 30 + hand_idx * 40),
                       cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 255, 0), 2)
            
            # Mouse control with index finger
            if mouse_control_mode and finger_count == 1:
                index_tip = landmarks[8]
                screen_x = int(index_tip.x * width)
                screen_y = int(index_tip.y * height)
                
                # Move mouse cursor (scaled for screen)
                try:
                    import pyautogui
                    pyautogui.moveTo(screen_x * 3, screen_y * 3)
                except:
                    pass
        
        # Calculate FPS
        frame_count += 1
        elapsed_time = time.time() - start_time
        if elapsed_time >= 1.0:
            fps = frame_count / elapsed_time
            frame_count = 0
            start_time = time.time()
        
        # Display FPS
        cv2.putText(annotated_frame, f"FPS: {int(fps)}", (10, 30),
                   cv2.FONT_HERSHEY_SIMPLEX, 0.7, (255, 0, 0), 2)
        
        # Display mouse control mode status
        mode_text = "Mouse: ON" if mouse_control_mode else "Mouse: OFF"
        cv2.putText(annotated_frame, mode_text, (10, 60),
                   cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 165, 255), 2)
        
        # Display instructions
        cv2.putText(annotated_frame, "Press 'q': Quit | 'f': Fullscreen | 'm': Mouse Mode",
                   (10, annotated_frame.shape[0] - 15),
                   cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 1)
        
        # Show the frame
        if fullscreen:
            cv2.namedWindow("Hand Tracking", cv2.WND_PROP_FULLSCREEN)
            cv2.setWindowProperty("Hand Tracking", cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)
            cv2.imshow("Hand Tracking", annotated_frame)
        else:
            cv2.imshow("Hand Tracking", annotated_frame)
        
        # Handle key presses
        key = cv2.waitKey(1) & 0xFF
        
        if key == ord('q'):
            print("\nQuitting application...")
            break
        elif key == ord('f'):
            fullscreen = not fullscreen
            if not fullscreen:
                cv2.destroyWindow("Hand Tracking")
        elif key == ord('m'):
            mouse_control_mode = not mouse_control_mode
            print(f"Mouse control mode: {'ON' if mouse_control_mode else 'OFF'}")
    
    # Clean up
    cap.release()
    cv2.destroyAllWindows()
    print("Application closed successfully!")

if __name__ == "__main__":
    main()

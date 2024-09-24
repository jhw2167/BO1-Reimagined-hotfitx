import pyautogui
import time

# Wait 5 seconds to allow you to switch to the game window
time.sleep(5)

# Move the mouse to coordinates (x, y) and click
pyautogui.moveTo(100, 200)
pyautogui.click()

# Press a key (e.g., the space bar)
pyautogui.press('space')

# Press and hold a key (e.g., "w" for forward movement in many games)
pyautogui.keyDown('w')
time.sleep(2)  # Hold for 2 seconds
pyautogui.keyUp('w')

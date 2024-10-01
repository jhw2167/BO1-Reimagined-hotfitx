import pyautogui
import time

# Wait 5 seconds to allow you to switch to the game window
time.sleep(1)

print(" Starting clicker... ")
time.sleep(2)

# Number of cycles after which F11 will be pressed
n = 5  # Change this to your preferred cycle count

# Cycle counter
cycle_count = 0

# Infinite loop
while True:
    # Increment cycle count
    cycle_count += 1

    # Hold left mouse button down for 10 seconds
    pyautogui.mouseDown()
    time.sleep(10)
    pyautogui.mouseUp()

    # Check if the current cycle is divisible by n
    if cycle_count % n == 0:
        # Press F11 before waiting
        pyautogui.press('f11')

    # Wait for 5 seconds
    time.sleep(5)

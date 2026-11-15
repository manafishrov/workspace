# Testing

End-to-end tests for app and firmware release candidates, run together on a
real ROV. Each repository's CI covers its own unit tests; this checklist covers
what only shows up end to end.

Record each test as OK, failed, or not tested, with a note for anything
unexpected. Test numbers are stable, so add new tests at the end rather than
renumbering.

## Tests

1. Open the app and connect to the ROV. **Expected:** the camera stream and HUD
   readings appear.
2. Click Flash Pico in the MCU tab, then spin every thruster from the
   calibration tab. **Expected:** the Pico flashes successfully and all
   thrusters spin.
3. Change one setting, leave settings, then open settings again.
   **Expected:** a toast confirms the change and the setting persists.
4. Save the config as JSON, change one setting, then load the saved config.
   **Expected:** the saved config loads and the changed setting is restored.
5. Turn on auto-stabilization. **Expected:** the thrusters slowly speed up as
   the regulator's integral term builds up. IJKL moves the desired attitude
   smoothly.
6. Start and stop a video recording. **Expected:** the recording is saved and
   plays from the file browser.
7. Move the ROV and watch the attitude indicators. **Expected:** pitch, roll
   and heading follow the ROV.
8. Read the battery level. **Expected:** a realistic battery percentage.
9. Connect a controller. **Expected:** it shows up in settings and keybinds can
   be set without problems.
10. Open the debug tab in settings and export the logs. **Expected:** logs
    stream and the export contains them.
11. Set the camera resolution to the highest and then the lowest option.
    **Expected:** the stream keeps working without errors or crashes.
12. Switch the thruster protocol from DShot to PWM and back to DShot.
    **Expected:** the switch works both ways and the thrusters run on DShot
    afterwards.
13. Change the ROV's IP address and the app's ROV address. **Expected:** they
    connect only when the addresses match.
14. Downgrade to the previous app version from the in-app update menu, then
    update back to the newest. **Expected:** both versions run without errors.
15. Flash the ESCs from the app (Manafish AM32 ESCs only). **Expected:** the
    ESCs flash successfully, all thrusters spin from the calibration tab, and
    ESC temperature, battery and current show correctly on the HUD.
16. Disconnect the IMU, the Pico and the pressure sensor one at a time.
    **Expected:** only the disconnected part turns red in system health. With
    the Pico disconnected, the IMU turns red too.
17. Install the CPU temperature test custom action, once by uploading the file
    and once by pasting its source. **Expected:** both installs work, its HUD
    element works, CSV logging works, and the Fahrenheit/Celsius toggle works.
18. On a freshly flashed SD card, open the custom actions tab. Enable the
    blackbox default, wait a while, then download its CSV. **Expected:** the
    water sensor, blackbox and extended telemetry defaults are installed and
    disabled, and the CSV contains the recorded data.
19. Download a model in the Object Detection tab, enable it, and turn on
    labels and track IDs. **Expected:** it detects simple objects, and the
    status in the tab shows realistic values.
20. Import an ONNX model file and enable it in the Object Detection tab.
    **Expected:** it imports without errors and detects simple objects.
21. In the appearance tab, add every HUD element type and try every size,
    including resizing elements after they are placed. **Expected:** every
    element displays correctly at every size, the picker has no duplicate
    elements, and the attitude indicators stay correct after resizing.
22. Select a thrust allocation preset and click Generate nullspace vectors.
    **Expected:** the vectors are generated without errors.
23. Flash an SD card from the app. **Expected:** the card flashes, the ROV
    boots from it and connects. No console windows open on Windows.
24. Boot a fresh SD card in a ROV whose Pico runs older firmware, and again
    with a blank Pico. **Expected:** the Pico is flashed automatically on
    first boot, its version shows in the MCU tab, and the thrusters work
    without clicking Flash Pico.
25. Edit several regulator values in a row, clicking straight into the next
    field after each one. **Expected:** the next field keeps focus when the
    save toast appears.
26. Trigger an error with a long message, such as importing an invalid model.
    **Expected:** the toast text wraps and stays on screen.
27. Take a photo from the HUD. **Expected:** a full-resolution photo is saved
    once and the stream keeps running.
28. Use depth hold and set a desired depth (pressure sensor required).
    **Expected:** the ROV holds and moves to the desired depth.
29. Drive the ROV with the keyboard, then with the controller. **Expected:**
    every bound action works and movement stops when input is released.
30. Run tests 1, 6, 19 and 27 on iOS and Android, using touch controls.
    **Expected:** connecting, streaming, recording, photos and detection work,
    and files save to the chosen directories.
31. Connect an app and firmware pair that are not marked compatible.
    **Expected:** the app shows the compatibility warning.

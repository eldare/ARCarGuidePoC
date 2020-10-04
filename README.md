# AR Car Guide PoC

Detects parts under a hood of a motor vehicle, and tracks the detected parts in AR.<br>
Tap AR entities to get more information about the part.

This is a PoC project, designed to detect a handful of Mazda 3 parts.

### Using
- `ARKit`
- `Vision` with a self taught `CoreML` model
- `RealityKit` with `RealityComposer`


## TODOs:
- edit Cooler Fluid Container content json description
- retrain the model
- Details VC 
    - rich text body: text color, weights, web links (open external safari) - maybe with Markdown instead of JSON (the title will be in markdown too)
    - accessability reader: change text size, font, BG and Foreground text color 
- mainVC bottom menu (just an icon with BG shadow) - will present a modal with About and Settings
- RealityComposer should be named identically to ML Model classes
- App Icon
- Basic splash screen

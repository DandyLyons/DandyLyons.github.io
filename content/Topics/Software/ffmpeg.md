---
publish: true
docs: https://ffmpeg.org/ffmpeg.html
---
## Tutorials
- [OS X Screencast to animated GIF · GitHub](https://gist.github.com/dergachev/4627207) 
### How to convert any video to [[gif]] using ffmpeg
To convert any file to a GIF using FFmpeg, you can follow these steps:

1. **Install FFmpeg**: Ensure you have FFmpeg installed on your system. You can check if it's installed by running `ffmpeg -version`.
2. **Create a Custom Palette**: Generate a custom palette of 256 colors specific to your video file using the following command:
```zsh
ffmpeg -ss 00:01:30 -t 5 -i video.mkv -filter_complex "[0:v] palettegen" palette.png
```

- `-ss`: Sets the starting point of the video.
- `-t`: Sets the duration (e.g., 5 seconds).
- `-i`: Specifies the input video file.

3. **Create the GIF**: Use the custom palette to create the GIF with this command:
```zsh
ffmpeg -ss 00:01:30 -t 5 -i video.mkv -i palette.png -filter_complex "[0:v] fps=10,scale=720:-1 [new];[new][1:v] paletteuse" output.gif
```

- `fps`: Specifies the frame rate of the output GIF.
- `scale`: Resizes the video while maintaining aspect ratio.
- `paletteuse`: Applies the custom palette to generate the GIF.

### Further Reading
- [How to Make a GIF from a Video Using FFmpeg - Bannerbear](https://www.bannerbear.com/blog/how-to-make-a-gif-from-a-video-using-ffmpeg/) 
- [How to Convert Videos to GIFs Using FFmpeg | Baeldung on Linux](https://www.baeldung.com/linux/convert-videos-gifs-ffmpeg)

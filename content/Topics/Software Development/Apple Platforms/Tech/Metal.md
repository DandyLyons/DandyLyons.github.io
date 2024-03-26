---
publish: true
docs: https://developer.apple.com/documentation/metal
---

## uv mapping in Metal
- [SwiftUI + Metal – Create special effects by building your own shaders - YouTube](https://youtu.be/EgzWwgRpUuw?feature=shared&t=1567) at 26:07
- What is [UV mapping](https://en.wikipedia.org/wiki/UV_mapping)?
	- Essentially UV Mapping is altering the position calculations from absolute pixel values to relative ratio values. 

### Case study
```c++
// Called in SwiftUI using .colorEffect()
[[ stitchable ]] float2 wave(
	float2 position, float time, float2 rect) {
		float2 uv = position / rect; // 👈🏼
		pos.y += sin(time * 5 + position.y / 20) * 5;
		return position;
	}
)
```


| Width | X   | UV   |
| ----- | --- | ---- |
| 100   | 0   | 0    |
| 100   | 50  | 0.5  |
| 200   | 50  | 0.25 |

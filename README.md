The goal of this code is to assess the ratio between heterotrophs and cyanobacteria in joint communities
found on rock samples collected from monuments in the DC area.

Directions for Heterotroph to Cyanobacterial Ratio Determination
1.	Open desired file in ImageJ (Fiji)
2.	Split channels and only keep red and green channels
3.	On red channel press image, adjust, brightness/contrast
4.	Adjust brightness and contrast so that all cells are visible but not too much to the point that the red starts smearing (too bright)
5.	Press apply
6.	Do the same for the green channel
7.	Merge the channels and 3D view it 
8.	Split channels 
9.	Save green channel File -> Save as -> C1-name.tif
10.	Save red channel File -> Save as -> C1-name.tif
11.	To subtract any nuclei (yellow color with red and green signal) 
Cyanobacteria (tif) -> Process -> Grey Morphology radius = 2 circle and operator close -> Image -> Adjust -> Color Balance 10-120
Green -> Process -> Image Calculator -> C1 Subtract C2 -> new file -> Color Balance 100-170 to select cells from eDNA.
Once done close the red channel WITHOUT saving changes.
12.	Open the green channel .tif Process -> Image Calculator -> C1 Subtract C2 -> new file -> Color Balance 100-170 -> Save as -> C1-nameA.tif (A indicates the C1 channel that has been adjusted.
13.	Move the C1-nameA adjusted image and the C2-red image
14.	Open MATLAB folder containing the rock_quant_code.m program and add the C1-nameA adjusted cyanobacterial cells and the C2-name heterotroph channel
15.	Change cell volume name to match the file name exactly and insert them into the code.
16.	Press run (triangle in the top tool bar).
17.	When completed you will have 2-3D views of the green C1 heterotroph channel and red C2 Cyanobacteria channels and the ratio reported out in the program. The excel sheet with the data will appear in the folder with the MATLAB program. Move the images and data out of the MATLAB folder.
18.	The heterotrophs are trimmed to a cell volume of 1 automatically. The cyanobacterial volumes are trimmed to 1. The volumes are added and divided to obtain an adjusted ratio.

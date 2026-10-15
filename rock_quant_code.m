% Code for assessing various microscopy files looking at
% heterotroph/cyanobateria joint colonies on monument rock samples
% Generally, the same grey-scale thresholds below were used for each sample 
% (unless microscopy image dictated otherwise i.e. poor staining)
filename = 'cell_volumes_MEB_021622_Area11.xlsx'; %output, change to output file name that you'd like
EPS_staining=0; %0 = no, 1 = yes: Note, we currently do not use this feature
volume_threshold_h=1; % micrometer^3
volume_threshold_c=5; % micrometer^3

grey_threshold_H=50; %grey scale background heterotrophs
grey_threshold_C=50; %grey scale background cyanobacteria
grey_threshold_EPS= 50; %grey scale background EPS

solidity_threshold=.2; %solidity for eDNA removal

%be sure to list files as 1. Heterotrophs, 2. cyanobacteria, and 3. EPS
files_flourescent=["C1-MEB 021622 Area 11.tif","C3-MEB 021622 Area 11.tif","C2-MEB 021622 Area 11.tif"];
dx=0.2405002;
dy=0.2405002;
dz=0.2517703;
voxel_size=dx*dy*dz;
volume_threshold_c=volume_threshold_c/voxel_size;
volume_threshold_h=volume_threshold_h/voxel_size;
connectivity=18; %bwlabeln parameter


if EPS_staining==1
    %quantification WITH EPS staining
    EPS=tiffreadVolume(files_flourescent(3));
    H=tiffreadVolume(files_flourescent(1));
    H(find(EPS>20))=0;
    BW_H = bwareaopen(H>grey_threshold_H,floor(volume_threshold_h));
    labeled_H=bwlabeln(BW_H,18);
    a=regionprops3(labeled_H,"Solidity","Volume");
    cells_index=find((a.Solidity>solidity_threshold).*(a.Volume>=floor(volume_threshold_h)));
    EPS_index=find((a.Solidity<solidity_threshold).*(a.Volume>=floor(volume_threshold_h)));
    H_cells=double(ismember(labeled_H,cells_index));
    EPS_added=double(ismember(labeled_H,EPS_index));
    labeled_H_cells=bwlabeln(H_cells,connectivity);
    H_cell_volume=regionprops3(labeled_H_cells,"Volume","SurfaceArea","Orientation");
    volshow(H_cells)
    
    % eDNA quantification
    EPS_labeled=bwlabeln((EPS>grey_threshold_EPS)+EPS_added,connectivity);
    EPS_volume=regionprops3(EPS_labeled,"Volume","SurfaceArea","Orientation");
    volshow(EPS)
else
    %quantification WITHOUT EPS staining
    H=tiffreadVolume(files_flourescent(1));
    BW_H = bwareaopen(H>grey_threshold_H,floor(volume_threshold_h));
    labeled_H=bwlabeln(BW_H,18);
    a=regionprops3(labeled_H,"Solidity","Volume");
    cells_index=find((a.Solidity>solidity_threshold).*(a.Volume>=floor(volume_threshold_h)));
    H_cells=double(ismember(labeled_H,cells_index));
    labeled_H_cells=bwlabeln(H_cells,connectivity);
    H_cell_volume=regionprops3(labeled_H_cells,"Volume","SurfaceArea","Orientation");
    volshow(H_cells)

end 



% Cyanobacteria quantification
C=tiffreadVolume(files_flourescent(2));
cyanobacteria=(C>grey_threshold_C);
cyanobacteria=bwareaopen(cyanobacteria,floor(volume_threshold_c));
labeled_cyanobacteria_cells=bwlabeln(cyanobacteria,connectivity);
cyanobacteria_cell_volume=regionprops3(labeled_cyanobacteria_cells,"Volume","SurfaceArea","Orientation");
volshow(cyanobacteria)

% writing files
H_cell_volume.Volume=H_cell_volume.Volume.*voxel_size;
cyanobacteria_cell_volume.Volume=cyanobacteria_cell_volume.Volume.*voxel_size;
writetable(H_cell_volume, filename, 'Sheet', 'H cell props');
writetable(cyanobacteria_cell_volume, filename, 'Sheet', 'C cell props');
if EPS_staining==1
    EPS_volume.Volume=EPS_volume.Volume.*voxel_size;
    writetable(EPS_volume,filename,'Sheet','EPS props')
end 

disp('Volume cyanobacteria/ Volume heterotrophs:')
disp(sum(cyanobacteria_cell_volume.Volume)/sum(H_cell_volume.Volume))


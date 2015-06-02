function [sizeROI] = getSize(ROIonly,pixelW,sliceT)
% -------------------------------------------------------------------------
% function [sizeROI] = getSize(ROIonly,pixelW,sliceT)
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function computes the size (longest diameter) of the region of 
% interest (ROI) of an input volume.
% -------------------------------------------------------------------------
% INPUTS:
% - ROIonly: 3D array, with voxels outside the ROI set to NaNs.
% - pixelW: Pixel width, or in-plane resolution, in mm.
% - sliceT: Slice thickness, in mm.
% -------------------------------------------------------------------------
% OUTPUTS:
% - sizeROI: Longest diameter of the ROI, in mm.
% -------------------------------------------------------------------------
% AUTHOR(S): Martin Vallieres <mart.vallieres@gmail.com>
% -------------------------------------------------------------------------
% HISTORY:
% - Creation: May 2015
%--------------------------------------------------------------------------
% STATEMENT:
% This file is part of <https://github.com/mvallieres/radiomics/>, 
% a package providing MATLAB programming tools for radiomics analysis.
% --> Copyright (C) 2015  Martin Vallieres
%
%    This package is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This package is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this package.  If not, see <http://www.gnu.org/licenses/>.
% -------------------------------------------------------------------------

mask = ~isnan(ROIonly); % Find mask covering the ROI
vectX = zeros(1,8*size(mask,3));
vectY = zeros(1,8*size(mask,3));
vectZ = zeros(1,8*size(mask,3));

for i = 1:size(mask,3)
    temp = regionprops(mask(:,:,i),'Extrema');
    try
        temp = temp.Extrema;
        temp = temp';
        vectX((i-1)*8 + 1:i*8) = temp(1,:) * pixelW;
        vectY((i-1)*8 + 1:i*8) = temp(2,:) * pixelW;
        vectZ((i-1)*8 + 1:i*8) = (i-1) * sliceT;
    catch % Will always work, except when the first slice contains all zeros
        vectX((i-1)*8 + 1:i*8) = vectX(((i-1)-1)*8 + 1:(i-1)*8);
        vectY((i-1)*8 + 1:i*8) = vectY(((i-1)-1)*8 + 1:(i-1)*8);
        vectZ((i-1)*8 + 1:i*8) = vectZ(((i-1)-1)*8 + 1:(i-1)*8);
    end
end

max = 0;
for i = 1:8*size(mask,3) - 1
    for j = i + 1:8*size(mask,3)
       dist = (vectX(i)-vectX(j))^2 + (vectY(i)-vectY(j))^2 + (vectZ(i)-vectZ(j))^2;
       if dist > max
           max = dist;
       end
    end
end

sizeROI = sqrt(max);

end
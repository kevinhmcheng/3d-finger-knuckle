function [final_score] = compute_score(bitPlanesAx,bitPlanesAy,bitPlanesBx,bitPlanesBy)
score_map = [0.5,1,1,1,1,0,1,0.5,1,1,0,0.5,1,0.5,0.5,0];

%Rotating Planes A, Shifting Planes B
[rows, cols] = size(bitPlanesAx);
shiftLength_i = ceil(rows*0.25);
shiftLength_j = ceil(cols*0.25);
score = ones(2*shiftLength_i+1,2*shiftLength_j+1,21);

for degree = -10:1:10
    bitPlanesAx_R = imrotate(bitPlanesAx,degree,'crop');
    bitPlanesAy_R = imrotate(bitPlanesAy,degree,'crop');

    for shifti = -shiftLength_i:shiftLength_i
        for shiftj = -shiftLength_j:shiftLength_j
            new_bitPlanesAx = bitPlanesAx_R(1+shiftLength_i:rows-shiftLength_i,1+shiftLength_j:cols-shiftLength_j);%constant center part
            new_bitPlanesBx = bitPlanesBx(1+shiftLength_i+shifti:rows-shiftLength_i+shifti,1+shiftLength_j+shiftj:cols-shiftLength_j+shiftj);
            
            new_bitPlanesAy = bitPlanesAy_R(1+shiftLength_i:rows-shiftLength_i,1+shiftLength_j:cols-shiftLength_j);%constant center part
            new_bitPlanesBy = bitPlanesBy(1+shiftLength_i+shifti:rows-shiftLength_i+shifti,1+shiftLength_j+shiftj:cols-shiftLength_j+shiftj);

            Planes = score_map(new_bitPlanesAx*8+new_bitPlanesAy*4+new_bitPlanesBx*2+new_bitPlanesBy+1);

            score(shifti+shiftLength_i+1,shiftj+shiftLength_j+1,degree+11) = sum(Planes(:))/(rows-2*shiftLength_i)/(cols-2*shiftLength_j);
        end
    end
end
final_score = min(score(:));

end
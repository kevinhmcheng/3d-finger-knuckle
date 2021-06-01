type = 'forefinger';
session = 1;
basedir1 = 'data/subject';
out_dir1 = 'feature/subject';
downsample_factor = 0.1980/0.4235; %for getting [70x100] depth map for matching
basedir2 = ['/session' num2str(session) '/' type '/set'];
for subjectID = 1:2
    for setID = 1:2
        disp([num2str(subjectID) ',' num2str(setID) '...'])
        load([basedir1 num2str(subjectID) basedir2 num2str(setID) '/surfNormal.mat']);
        N = reshape(surfNormal,212,149,3);
        N = imresize(N, downsample_factor);
        N2 = permute(N,[2 1 3]);

        %% Normal Derivative
        Nx = N2(:,:,1)./abs(N2(:,:,3));
        Ny = N2(:,:,2)./abs(N2(:,:,3));
        [Nxx, Nxy] = gradient(Nx);
        [Nyx, Nyy] = gradient(Ny);

        NDx = Nxx<0;
        NDy = Nyy<0;

        mkdir([out_dir1 num2str(subjectID) basedir2 num2str(setID)]);
        save([out_dir1 num2str(subjectID) basedir2 num2str(setID) '/NDx.mat'],'NDx')
        save([out_dir1 num2str(subjectID) basedir2 num2str(setID) '/NDy.mat'],'NDy')
        imwrite(NDx,[out_dir1 num2str(subjectID) basedir2 num2str(setID) '/NDx.bmp'])
        imwrite(NDy,[out_dir1 num2str(subjectID) basedir2 num2str(setID) '/NDy.bmp'])
    end
end
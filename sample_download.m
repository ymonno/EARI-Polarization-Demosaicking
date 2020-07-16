function sample_download(path_to_dataset)

p = mfilename('fullpath');
[installDirec,] = fileparts(p);
if nargin ==0
    path_to_dataset = installDirec;
end
if ~exist(path_to_dataset)
    mkdir(path_to_dataset)
end

% download sample data
urlSampleData = 'http://www.ok.sc.e.titech.ac.jp/res/PolarDem/data/Input.zip';
filenameSampleData= path_to_dataset;
unzip(urlSampleData,filenameSampleData)

end
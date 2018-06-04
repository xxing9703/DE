function y=LV_fit01(x,vi) 
%e=actxserver('LabVIEW.Application');
%vipath='C:\Users\xxing\Documents\MATLAB\Daoyi_DE\fit01.vi';
%vi=invoke(e,'GetVIReference',vipath);
vi.SetControlValue('input',x);
vi.Run;
y=-vi.GetControlValue('fitness');
function [cumpress,press] = crossval_pls(x,y,lvs,blocks_r,prepx,prepy,opt)

% Row-wise k-fold (rkf) cross-validation for square-prediction-errors computing in PLS.
%
% [cumpress,press] = crossval_pls(x,y,lvs) % minimum call
% [cumpress,press] =
% crossval_pls(x,y,lvs,blocks_r,blocks_c,prepx,prepy,opt) % complete call
%
%
% INPUTS:
%
% x: [NxM] billinear data set for model fitting
%
% y: [NxO] billinear data set of predicted variables
%
% lvs: [1xA] Latent Variables considered (e.g. lvs = 1:2 selects the
%   first two LVs). By default, lvs = 0:rank(x)
%
% blocks_r: [1x1] maximum number of blocks of samples (N by default)
%
% prepx: [1x1] preprocesing of the x-block
%       0: no preprocessing
%       1: mean centering
%       2: autoscaling (default)  
%
% prepy: [1x1] preprocesing of the y-block
%       0: no preprocessing
%       1: mean centering
%       2: autoscaling (default)  
%
% opt: [1x1] options for data plotting
%       0: no plots
%       1: bar plot (default)
%
%
% OUTPUTS:
%
% cumpress: [Ax1] Cumulative PRESS
%
% press: [AxO] PRESS per variable.
%
%
% EXAMPLE OF USE: Random data with structural relationship
%
% X = real(ADICOV(randn(10,10).^9,randn(100,10),10));
% Y = randn(100,2) + X(:,1:2);
% lvs = 0:10;
% cumpress = crossval_pls(X,Y,lvs);
%
%
% coded by: Jose Camacho Paez (josecamacho@ugr.es)
% last modification: 30/Mar/16.
%
% Copyright (C) 2014  University of Granada, Granada
% Copyright (C) 2014  Jose Camacho Paez
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.


%% Arguments checking

% Set default values
routine=dbstack;
assert (nargin >= 2, 'Error in the number of arguments. Type ''help %s'' for more info.', routine.name);
N = size(x, 1);
M = size(x, 2);
O = size(y, 2);
if nargin < 3 || isempty(lvs), lvs = 0:rank(x); end;
A = length(lvs);
if nargin < 4 || isempty(blocks_r), blocks_r = N; end;
if nargin < 5 || isempty(prepx), prepx = 2; end;
if nargin < 6 || isempty(prepy), prepy = 2; end;
if nargin < 7 || isempty(opt), opt = 1; end;

% Convert column arrays to row arrays
if size(lvs,2) == 1, lvs = lvs'; end;

% Validate dimensions of input data
assert (isequal(size(y), [N O]), 'Dimension Error: 2nd argument must be N-by-O. Type ''help %s'' for more info.', routine.name);
assert (isequal(size(lvs), [1 A]), 'Dimension Error: 3rd argument must be 1-by-A. Type ''help %s'' for more info.', routine.name);
assert (isequal(size(blocks_r), [1 1]), 'Dimension Error: 4th argument must be 1-by-1. Type ''help %s'' for more info.', routine.name);
assert (isequal(size(prepx), [1 1]), 'Dimension Error: 5th argument must be 1-by-1. Type ''help %s'' for more info.', routine.name);
assert (isequal(size(prepy), [1 1]), 'Dimension Error: 6th argument must be 1-by-1. Type ''help %s'' for more info.', routine.name);
assert (isequal(size(opt), [1 1]), 'Dimension Error: 7th argument must be 1-by-1. Type ''help %s'' for more info.', routine.name);

% Preprocessing
lvs = unique(lvs);

% Validate values of input data
assert (isempty(find(lvs<0)), 'Value Error: 3rd argument must not contain negative values. Type ''help %s'' for more info.', routine.name);
assert (isequal(fix(lvs), lvs), 'Value Error: 3rd argumentmust contain integers. Type ''help %s'' for more info.', routine.name);
assert (isequal(fix(blocks_r), blocks_r), 'Value Error: 4th argument must be an integer. Type ''help %s'' for more info.', routine.name);
assert (blocks_r>2, 'Value Error: 4th argument must be above 2. Type ''help %s'' for more info.', routine.name);
assert (blocks_r<=N, 'Value Error: 4th argument must be at most N. Type ''help %s'' for more info.', routine.name);


%% Main code

% Initialization
cumpress = zeros(max(lvs)+1,1);
press = zeros(max(lvs)+1,O);

rows = rand(1,N);
[a,r_ind]=sort(rows);
elem_r=N/blocks_r;


% Cross-validation
        
for i=1:blocks_r,
    
    ind_i = r_ind(round((i-1)*elem_r+1):round(i*elem_r)); % Sample selection
    i2 = ones(N,1);
    i2(ind_i)=0;
    sample = x(ind_i,:);
    calibr = x(find(i2),:); 
    sample_y = y(ind_i,:);
    calibr_y = y(find(i2),:); 

    [ccs,av,st] = preprocess2D(calibr,prepx);
    [ccs_y,av_y,st_y] = preprocess2D(calibr_y,prepy);
        
    scs=sample;
    scs_y=sample_y;
    for j=1:length(ind_i),
        scs(j,:) = (sample(j,:)-av)./st;
        scs_y(j,:) = (sample_y(j,:)-av_y)./st_y;
    end
    
    [beta,W,P,Q,R] = kernel_pls(ccs'*ccs,ccs'*ccs_y,max(lvs));
    
    for lv=lvs,
    
        if lv > 0,
            beta = R(:,max(min(lvs),1):lv)*Q(:,max(min(lvs),1):lv)';
            srec = scs*beta;
            
            pem = scs_y-srec;
            
        else % Modelling with the average
            pem = scs_y;
        end
        
        press(lv+1,:) = press(lv+1,:) + sum(pem.^2,1);
        
    end
end

cumpress = sum(press,2);

%% Show results

if opt == 1,
    fig_h = plot_vec(cumpress(lvs+1),lvs,[],{'PRESS','#LVs'},[],1); 
end


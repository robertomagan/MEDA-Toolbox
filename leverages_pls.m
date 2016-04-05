
function L = leverages_pls(x,y,lvs,prepx,prepy,opt,label,classes)

% Compute and plot loadings in PLS
%
% L = leverages_pls(x,y) % minimum call
% L = leverages_pls(x,y,lvs,prepx,prepy,opt,label,classes) % complete call
%
% INPUTS:
%
% x: [NxM] billinear data set for model fitting
%
% y: [NxO] billinear data set of predicted variables
%
% lvs: [1xA] Latent Variables considered (e.g. lvs = 1:2 selects the
%   first two LVs). By default, lvs = 1:rank(x)
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
%       otherwise: bar plot of leverages
%
% label: [Mx1] (opt = 1 o 2), [Ox1] (opt = otherwise), name of the 
%   variables (numbers are used by default)
%
% classes: [Mx1] (opt = 1 o 2), [Ox1] (opt = otherwise), groups for 
%   different visualization (a single group by default)
%
%
% OUTPUTS:
%
% L: [Mx1] leverages of the variables
%
%
% EXAMPLE OF USE: Random loadings: bar and scatter plot of weights
%
% X = real(ADICOV(randn(10,10).^19,randn(100,10),10));
% Y = randn(100,2) + X(:,1:2);
% L = leverages_pls(X,Y,1:3);
%
%
% coded by: Jose Camacho Paez (josecamacho@ugr.es)
%           Alejandro Perez Villegas (alextoni@gmail.com)
% last modification: 05/Apr/2016
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

%% Parameters checking

% Set default values
routine=dbstack;
assert (nargin >= 2, 'Error in the number of arguments. Type ''help %s'' for more info.', routine(1).name);
N = size(x, 1);
M = size(x, 2);
O = size(y, 2);
if nargin < 3 || isempty(lvs), lvs = 1:rank(x); end;
if nargin < 4 || isempty(prepx), prepx = 2; end;
if nargin < 5 || isempty(prepy), prepy = 2; end;
if nargin < 6 || isempty(opt), opt = 1; end; 
if nargin < 7 || isempty(label), 
    switch opt,
        case {0}
            label = []; 
        case {1,2} 
            label = [1:M]; 
            K = M;
        otherwise
            label = [1:O]; 
            K = O;
    end
end
if nargin < 8 || isempty(classes), 
    switch opt,
        case {0}
            classes = []; 
        case {1,2} 
            classes = ones(M,1); 
            K = M;
        otherwise
            classes = ones(O,1); 
            K = O;
    end
end

% Convert row arrays to column arrays
if size(label,1) == 1,     label = label'; end;
if size(classes,1) == 1, classes = classes'; end;

% Convert column arrays to row arrays
if size(lvs,2) == 1, lvs = lvs'; end;

% Preprocessing
lvs = unique(lvs);
lvs(find(lvs==0)) = [];
A = length(lvs);

% Validate dimensions of input data
assert (isequal(size(lvs), [1 A]), 'Dimension Error: 3rd argument must be 1-by-A. Type ''help %s'' for more info.', routine(1).name);
assert (isequal(size(prepx), [1 1]), 'Dimension Error: 4th argument must be 1-by-1. Type ''help %s'' for more info.', routine(1).name);
assert (isequal(size(prepy), [1 1]), 'Dimension Error: 5th argument must be 1-by-1. Type ''help %s'' for more info.', routine(1).name);
assert (isequal(size(opt), [1 1]), 'Dimension Error: 6th argument must be 1-by-1. Type ''help %s'' for more info.', routine(1).name);
if ~isempty(label), assert (isequal(size(label), [K 1]), 'Dimension Error: 7th argument must be K-by-1. Type ''help %s'' for more info.', routine(1).name); end;
if ~isempty(classes), assert (isequal(size(classes), [K 1]), 'Dimension Error: 8th argument must be K-by-1. Type ''help %s'' for more info.', routine(1).name); end;
  
% Validate values of input data
assert (isempty(find(lvs<0)) && isequal(fix(lvs), lvs), 'Value Error: 3rd argument must contain positive integers. Type ''help %s'' for more info.', routine(1).name);


%% Main code

xcs = preprocess2D(x,prepx);
ycs = preprocess2D(y,prepy);

[beta,W,P,Q] = kernel_pls(xcs'*xcs,xcs'*ycs,lvs);

L = diag(W*W');


%% Show results

if opt,
    plot_vec(L, label, classes, {'Variables','Leverages'});
end
        
function varargout = PCA(varargin)

%%
%GUI for Principal Components Analysis (PCA) analysis
%
%This M-file include routines from the EDA Toolbox: 
%loading_pca.m, meda_pca.m, omeda_pca.m, pca_pp.m, scores_pca.m,
%sqresiduals_pca.m and var_pca.m
%
% coded by: Elena Jiménez Mañas (elenajm@correo.ugr.es).
%           Rafael Rodriguez Gomez (rodgom@ugr.es)
% version: 2.0
% last modification: 31/Jan/15.
%
% Copyright (C) 2014  Elena Jiménez Mañas
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

% PCA M-file for PCA.fig
%      PCA, by itself, creates a new PCA or raises the existing
%      singleton*.
%
%      H = PCA returns the handle to a new PCA or the handle to
%      the existing singleton*.
%
%      PCA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PCA.M with the given input arguments.
%
%      PCA('Property','Value',...) creates a new PCA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PCA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PCA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PCA

% Last Modified by GUIDE v2.5 03-Feb-2015 18:39:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @PCA_OpeningFcn, ...
    'gui_OutputFcn',  @PCA_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before PCA is made visible.
function PCA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PCA (see VARARGIN)

% Choose default command line output for PCA
handles.output = hObject;

%Definici�n del estado inicial de la interfaz gr�fica PCA:

%Score plot
set(handles.text7,'Enable','off');
set(handles.text8,'Enable','off');
set(handles.xpcscorePopup,'Enable','off');
set(handles.ypcscorePopup,'Enable','off');
set(handles.text13,'Enable','off');
set(handles.text14,'Enable','off');
set(handles.classcorePopup,'Enable','off');
set(handles.labscorePopup,'Enable','off');
set(handles.scoreButton,'Enable','off');

%MEDA
set(handles.medaPopup,'Enable','off');
set(handles.medaPopup,'String',' ');
set(handles.text5,'Enable','off');
set(handles.thresEdit,'Enable','off');
set(handles.thresRadio,'Enable','off');
set(handles.serRadio,'Enable','off');
set(handles.medaButton,'Enable','off');
set(handles.selmedaButton,'Enable','off');

%oMEDA
set(handles.omedaButton,'Enable','off');
set(handles.selomedaButton,'Enable','off');
set(handles.minusButton,'Enable','off');
set(handles.plusButton,'Enable','off');
set(handles.cleanButton,'Enable','off');
set(handles.trendButton,'Enable','off');

%Loading plot
set(handles.text9,'Enable','off');
set(handles.text10,'Enable','off');
set(handles.xpcvarPopup,'Enable','off');
set(handles.ypcvarPopup,'Enable','off');
set(handles.text17,'Enable','off');
set(handles.text18,'Enable','off');
set(handles.clasvarPopup,'Enable','off');
set(handles.labvarPopup,'Enable','off');
set(handles.medaButton,'Enable','off');
set(handles.loadingButton,'Enable','off');

%Residue
set(handles.resomedaButton,'Enable','off');
set(handles.resvarButton,'Enable','off');

%Model
set(handles.modelomedaButton,'Enable','off');
set(handles.modelmedaButton,'Enable','off');

%Summary Panel:
handles.data.sumtext = [];

%Information Panel:
handles.data.messageNum=0;
handles.data.messageNum_max=10;
handles.data.text=[];
information_message(handles);

%Variables initialization:
handles.data.PCs=[];
handles.data.PC1=[];
handles.data.PC2=[];
handles.data.weightDummy=cell(1,1000);
handles.data.dummy={};
handles.data.sp_ID_figures=[];
handles.data.sp_matrix={};
handles.data.clean_control=zeros(1,1000);
handles.data.lp_ID_figures=[];
handles.data.lp_matrix={};
handles.data.PC1_LP=[];
handles.data.PC2_LP=[];
handles.data.control_Refresh=0;
handles.data.CORTES={};
handles.data.matrix_2PCs={};
handles.data.PCs_MEDA='';
handles.data.auxPCs=0;

%Change icon
%warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
%javaFrame = get(hObject,'JavaFrame');
%javaFrame.setFigureIcon(javax.swing.ImageIcon('icon.jpg'));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PCA wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PCA_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PCA Analysis%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function to get the current string in a popupmenu
function str = getCurrentPopupString(hh)
%# getCurrentPopupString returns the currently selected string in the popupmenu with handle hh

%# could test input here
if ~ishandle(hh) || strcmp(get(hh,'Type'),'popupmenu')
error('getCurrentPopupString needs a handle to a popupmenu as input')
end

%# get the string - do it the readable way
list = get(hh,'String');
val = get(hh,'Value');
if iscell(list)
   str = list{val};
else
   str = list(val,:);
end

% --- Executes on selection change in dataPopup.
%dataPopup==Data
function dataPopup_Callback(hObject, eventdata, handles)
% hObject    handle to dataPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dataPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dataPopup

incoming_data=get(hObject,'Value');%Incoming data position
string_evaluation=handles.data.WorkSpace{incoming_data};%Name of the incoming data position
data_matrix=evalin('base',string_evaluation);%Data content in that name
handles.data.data_matrix=data_matrix;

%Summary Panel
[M N]=size(data_matrix);
sumtext = sprintf('Data Loaded:\n%s - > <%dx%d>\nMin %d\nMax %d',string_evaluation,M,N,min(min(data_matrix)),max(max(data_matrix)));
handles.data.sumtext=cprint(handles.sumText,sumtext,handles.data.sumtext,0);

%Change the selectPopup
cellPopup = cell(1,N);
for i=1:N
    cellPopup{i} = num2str(i);
end
set(handles.selectPopup,'String',cellPopup);

%Initialize dummy variable:
M=size(data_matrix,1);%Number of observations
dummy=zeros(1,M);
handles.data.dummyRED=dummy;
handles.data.dummyGREEN=dummy;

set(handles.labscorePopup,'Value',1);
handles.data.label={};
set(handles.classcorePopup,'Value',1);
handles.data.classes=[];
set(handles.labvarPopup,'Value',1);
handles.data.label_LP={};
set(handles.clasvarPopup,'Value',1);
handles.data.classes_LP=[];

handles.data.namePopupmenu6=string_evaluation;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function dataPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
handles.data.namePopupmenu6='';
handles.data.data_matrix=[];
handles.data.WorkSpace=evalin('base','who');%name of the variables in the workspace

if ~isempty(handles.data.WorkSpace),
    set(hObject,'String',handles.data.WorkSpace);
    string_evaluation=handles.data.WorkSpace{1};%Name of the incoming data position
    data_matrix=evalin('base',string_evaluation);%Data content in that name
    handles.data.data_matrix=data_matrix;
    handles.data.namePopupmenu6=string_evaluation;
    %Initialize dummy variable:
    M=size(data_matrix,1);%Number of observations
    dummy=zeros(1,M);
    handles.data.dummyRED=dummy;
    handles.data.dummyGREEN=dummy;
else
    set(hObject,'String',' ');
end

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

guidata(hObject, handles);


% --- Executes on button press in pushbutton1.
%pushbutton1==Refresh
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.WorkSpace=evalin('base','who');

if ~isempty(handles.data.WorkSpace),
    
    set(handles.dataPopup, 'String', handles.data.WorkSpace);
    nombres=cellstr(get(handles.dataPopup,'String'));
    if ~isempty(handles.data.namePopupmenu6),
        for i=1:length(nombres),
            if strcmp(nombres(i),handles.data.namePopupmenu6),
                val=i;
            end
        end
        set(handles.dataPopup,'Value',val);
        handles.data.data_matrix=evalin('base',handles.data.WorkSpace{val});
    end
    %Para que la primera vez que se pulse Refresh con el workspace distinto
    %de vacio coja la primera matriz automaticamente
    if handles.data.control_Refresh==0 && isempty(handles.data.data_matrix),
        string_evaluation=handles.data.WorkSpace{1};
        data_matrix=evalin('base',string_evaluation);
        handles.data.data_matrix=data_matrix;
        handles.data.namePopupmenu6=string_evaluation;
    end
    
    %Refresh the Label and Classes popupmenus:
    contents=get(handles.classcorePopup,'String');
    aux=[];
    for i=1:length(handles.data.WorkSpace),
        aux=[aux handles.data.WorkSpace(i,:)];
    end
    a1=contents(1,:);
    for j=1:length(a1),
        if ~isspace(a1(j)),
            b1(j)=a1(j);
        end
    end
    aux=[b1,aux];
    set(handles.classcorePopup,'String',strvcat(aux));
    nombres=cellstr(get(handles.classcorePopup,'String'));
    if ~strcmp(handles.data.namePopupmenu15,'emptyclasses'),
        for i=1:length(nombres),
            if strcmp(nombres(i),handles.data.namePopupmenu15),
                val=i;
            end
        end
        set(handles.classcorePopup,'Value',val);
        handles.data.classes=evalin('base',handles.data.WorkSpace{val-1});    
    end
    
    contents=get(handles.labscorePopup,'String');
    aux2=[];
    for i=1:length(handles.data.WorkSpace),
        aux2=[aux2 handles.data.WorkSpace(i,:)];
    end
    a2=contents(1,:);
    for j=1:length(a2),
        if ~isspace(a2(j)),
            b2(j)=a2(j);
        end
    end
    aux2=[b2,aux2];
    set(handles.labscorePopup,'String',strvcat(aux2));
    nombres=cellstr(get(handles.labscorePopup,'String'));
    if ~strcmp(handles.data.namePopupmenu16,'emptylabel'),
        for i=1:length(nombres),
            if strcmp(nombres(i),handles.data.namePopupmenu16),
                val=i;
            end
        end
        set(handles.labscorePopup,'Value',val);
        handles.data.label=evalin('base',handles.data.WorkSpace{val-1});    
    end
    
    
    contents=get(handles.clasvarPopup,'String');
    aux3=[];
    for i=1:length(handles.data.WorkSpace),
        aux3=[aux3 handles.data.WorkSpace(i,:)];
    end
    a3=contents(1,:);
    for j=1:length(a3),
        if ~isspace(a3(j)),
            b3(j)=a3(j);
        end
    end
    aux3=[b3,aux3];
    set(handles.clasvarPopup,'String',strvcat(aux3));
    nombres=cellstr(get(handles.clasvarPopup,'String'));
    if ~strcmp(handles.data.namePopupmenu19,'emptyclasses'),
        for i=1:length(nombres),
            if strcmp(nombres(i),handles.data.namePopupmenu19),
                val=i;
            end
        end
        set(handles.clasvarPopup,'Value',val);
        handles.data.classes_LP=evalin('base',handles.data.WorkSpace{val-1});    
    end
    
    contents=get(handles.labvarPopup,'String');
    aux4=[];
    for i=1:length(handles.data.WorkSpace),
        aux4=[aux4 handles.data.WorkSpace(i,:)];
    end
    a4=contents(1,:);
    for j=1:length(a4),
        if ~isspace(a4(j)),
            b4(j)=a4(j);
        end
    end
    aux4=[b4,aux4];
    set(handles.labvarPopup,'String',strvcat(aux4));
    nombres=cellstr(get(handles.labvarPopup,'String'));
    if ~strcmp(handles.data.namePopupmenu20,'emptylabel'),
        for i=1:length(nombres),
            if strcmp(nombres(i),handles.data.namePopupmenu20),
                val=i;
            end
        end
        set(handles.labvarPopup,'Value',val);
        handles.data.label_LP=evalin('base',handles.data.WorkSpace{val-1});    
    end
    
    handles.data.control_Refresh=1;
else
    set(handles.dataPopup, 'String', ' ');
    handles.data.data_matrix=[];
    
    contents=get(handles.classcorePopup,'String');
    aux=[];
    aux=[contents(1,:),aux];
    
    contents=get(handles.labscorePopup,'String');
    aux2=[];
    aux2=[contents(1,:),aux2];
    
    contents=get(handles.clasvarPopup,'String');
    aux3=[];
    aux3=[contents(1,:),aux3];
    
    contents=get(handles.labvarPopup,'String');
    aux4=[];
    aux4=[contents(1,:),aux4];
    
    %TODO substitute by error dialog
    %Information panel:
    text=sprintf('Warning: No data matrices in workspace.');
    handles.data.sumtext=cprint(handles.sumText,text,handles.data.sumtext,0);
end

handles.data.new2=aux;
handles.data.new1=aux2;
handles.data.new4=aux3;
handles.data.new3=aux4;
guidata(hObject,handles);

%edit text==PCs
function pcEdit_Callback(hObject, eventdata, handles)
% hObject    handle to pcEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pcEdit as text
%        str2double(get(hObject,'String')) returns contents of pcEdit as a double
PCs=str2num(get(hObject,'String'));

handles.data.PCs = PCs;

guidata(hObject,handles);

% Fuction to show the corresponding message in the information panel
function information_message(handles)
    switch handles.data.messageNum
        case 0
            text=sprintf('To begin the analysis:\nChoose a data matrix and select the preprocessing of the data from the corresponding popupmenus. If no data appears, please charge it from WorkSpace by clicking on REFRESH button.');
        case 1
            text=sprintf('Enter the number of principal components in the general plots section and select between Var X, Var X + ckf, SVI plot, ekf crossval and cekf crossval. If SVI plot is selected a PC should be additionally chosen.\nThen press the plot button.');
        case 2
            text=sprintf('Enter the number of principal components to work with and press on the PCA button to perform the initial analysis and activate the Score Plot, Loading Plot and MEDA menus.');
        case 3
            text=sprintf('Plot a Score plot, a Loading plot, a MEDA plot or Residual/Model plot, by clicking on  the proper menu.');
        case 4
            text=sprintf('Label is a cell having this format:\n{`x`,`x`,`y`,`y`,...,`z`,`z`}, containing as many tags as the number of observations.');
        case 5
            text=sprintf('Classes is an array having this format:\n[1,1,2,2,...,3,3], containing as many entries as the number of observations.');
        case 6
            text=sprintf('To use label or classes, define the tags or class cell arrays and charge it from the workspace by clicking on the REFRESH button.');
        case 7
            text=sprintf('To perform an oMEDA plot push on the SELECT button in the oMEDA menu (upon selection of a Score Plot).');
        case 8
            text=sprintf('Over the selected Score Plot draw a polinomial enclosing the required points and push on the (+) button to assign them +1 or on the (-) button to assign them -1.');
        case 9
            text=sprintf('Optionally push on the Trend button and draw a line over the Score Plot to include weigths in the analysis.\nFinally push on the Plot button to obtain the oMEDA plot.');
        case 10
            text=sprintf('To perform a MEDA plot, push on the SELECT button in the MEDA menu (upon selection of a Loading Plot).\nOver the selected Loading Plot draw a polinomial enclosing the required points.');
        otherwise
            disp('No case detected')
    end
    handles.data.text=cprint(handles.infoText,text,handles.data.text,0);


% --- Executes during object creation, after setting all properties.
function pcEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pcEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in generalButton.
%pushbutton==VAR
function generalButton_Callback(hObject, eventdata, handles)
% hObject    handle to generalButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[pc_num,status]=str2num(get(handles.generalEdit, 'String'));
sizeMat = size(handles.data.data_matrix);
if status == false
    errordlg('Please enter a number of PCs.');
    return;
elseif pc_num > sizeMat(2) || pc_num < 1
    errordlg(sprintf('The number of PCs can not exceed the number of variables in the data matrix which is %d.',sizeMat(2)));
    return;
end

%Detect the selected general plot and plot it
generalPlot = getCurrentPopupString(handles.generalPopup);
switch generalPlot
    case 'Var X'
        x_var = var_pca(handles.data.data_matrix,pc_num,handles.data.prep,1);
    case 'Var X + ckf'
        x_var = var_pca(handles.data.data_matrix,pc_num,handles.data.prep,2);
    case 'ekf crossval '
        x_var = crossval_pca(handles.data.data_matrix,0:pc_num,'ekf',Inf,Inf,handles.data.prep);
    case 'cekf crossval'
        x_var = crossval_pca(handles.data.data_matrix,0:pc_num,'cekf',Inf,Inf,handles.data.prep);
    case 'SVI plot'
        chosenVar = str2num(getCurrentPopupString(handles.selectPopup));
        SVIplot(handles.data.data_matrix,pc_num,chosenVar,7,handles.data.prep);
    otherwise
        disp('No case detected')
end

% --- Executes on selection change in prepPopup.
%prepPopup==Prep
function prepPopup_Callback(hObject, eventdata, handles)
% hObject    handle to prepPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns prepPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from prepPopup
nombres=cellstr(get(hObject,'String'));
val=nombres{get(hObject,'Value')};

switch val,
    case 'no preprocessing',
        prep=0;
        if handles.data.control==1,
            text = sprintf('Preprocessing of data matrix:\nNo preprocessing.');
            handles.data.sumtext=cprint(handles.sumText,text,handles.data.text,0);
        end
    case 'mean centering',
        prep=1;
        if handles.data.control==1,
            text = sprintf('Preprocessing of data matrix:\nMean Centering.');
            handles.data.sumtext=cprint(handles.sumText,text,handles.data.text,0);
        end
    case 'auto-scaling',
        prep=2;
        if handles.data.control==1,
            text = sprintf('Preprocessing of data matrix:\nAuto-scaling.');
            handles.data.sumtext=cprint(handles.sumText,text,handles.data.text,0);
        end
end

handles.data.prep = prep;
handles.data.control=1;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function prepPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prepPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'String',strvcat('no preprocessing','mean centering','auto-scaling'));

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.data.control=0;
set(hObject, 'Value', 2);%Default value for the preprocessing method: mean-centering
prepPopup_Callback(hObject, eventdata, handles)%Para llamar al valor por defecto


% --- Executes on button press in pcaButton.
%pcaButton==PCA
function pcaButton_Callback(hObject, eventdata, handles)
% hObject    handle to pcaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Information panel:
if isempty(handles.data.data_matrix),
    errordlg('No data matrix selected, please select one.');
    return;
end
[pc_num,status]=str2num(get(handles.pcEdit, 'String'));
sizeMat = size(handles.data.data_matrix);
if status == false
    errordlg('Please enter a number of PCs.');
    return;
elseif pc_num > sizeMat(2) || pc_num < 1
    errordlg(sprintf('The number of PCs can not exceed the number of variables in the data matrix which is %d.',sizeMat(2)));
    return;
end
handles.data.PCs=[1:pc_num];

%Si la variable handles.data.PCs es distinta de vacía, imprimir en xpcscorePopup,
%xpcvarPopup, ypcvarPopup y ypcscorePopup los PCs posibles.
if ~isempty(handles.data.PCs),
    set(handles.xpcscorePopup, 'String',handles.data.PCs);
    set(handles.ypcscorePopup, 'String',handles.data.PCs);
    set(handles.xpcvarPopup, 'String',handles.data.PCs);
    set(handles.ypcvarPopup, 'String',handles.data.PCs);
    
    %Imprimir en popupmenu de submenu MEDA todas las combinaciones posibles
    %para hacer MEDA
    k=min(handles.data.PCs);
    options=[];
    for i=min(handles.data.PCs):max(handles.data.PCs),
        for j=k:max(handles.data.PCs),
            options=[options,i,j];
        end
        k=k+1;
    end
    
    set(handles.medaPopup,'String','');
    for i=1:2:(length(options)-1),
        contents=get(handles.medaPopup,'String');
        set(handles.medaPopup,'String',strvcat(contents,sprintf('%d:%d',options(i),options(i+1))));
    end
end

if handles.data.auxPCs==0,
handles.data.PC1=min(handles.data.PCs);
handles.data.PC2=min(handles.data.PCs);
handles.data.PC1_LP=min(handles.data.PCs);
handles.data.PC2_LP=min(handles.data.PCs);
handles.data.PCs_MEDA=sprintf('%d:%d',min(handles.data.PCs),min(handles.data.PCs));
handles.data.auxPCs=1;
end

[handles.data.matrixLoadings,handles.data.matrixScores]=pca_pp(handles.data.data_matrix,max(handles.data.PCs));

%Definición del estado de la interfaz tras pulsar PCA:
%Score plot
set(handles.xpcscorePopup,'Enable','on');
set(handles.ypcscorePopup,'Enable','on');
set(handles.scoreButton,'Enable','on');
set(handles.text7,'Enable','on');
set(handles.text8,'Enable','on');
set(handles.text13,'Enable','on');
set(handles.text14,'Enable','on');
set(handles.classcorePopup,'Enable','on');
set(handles.labscorePopup,'Enable','on');

%MEDA
set(handles.thresRadio,'Enable','on');
set(handles.serRadio,'Enable','on');
set(handles.medaButton,'Enable','on');
set(handles.medaPopup,'Enable','on');

%Loading plot
set(handles.text9,'Enable','on');
set(handles.text10,'Enable','on');
set(handles.xpcvarPopup,'Enable','on');
set(handles.ypcvarPopup,'Enable','on');
set(handles.medaButton,'Enable','on');
set(handles.text17,'Enable','on');
set(handles.text18,'Enable','on');
set(handles.clasvarPopup,'Enable','on');
set(handles.labvarPopup,'Enable','on');
set(handles.loadingButton,'Enable','on');

%Residue
set(handles.resomedaButton,'Enable','on');
set(handles.resvarButton,'Enable','on');

%Model
set(handles.modelomedaButton,'Enable','on');
set(handles.modelmedaButton,'Enable','on');

%Information panel:
text=sprintf('Model generated successully!');
handles.data.sumtext=cprint(handles.sumText,text,handles.data.sumtext,0);

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function uipanel3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%Score Plot Submenu%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in xpcscorePopup.
%xpcscorePopup==PC X-axes
function xpcscorePopup_Callback(hObject, eventdata, handles)
% hObject    handle to xpcscorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns xpcscorePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from xpcscorePopup
incoming_data_PC1=get(hObject,'Value');%Incoming data position
handles.data.PC1=incoming_data_PC1;

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function xpcscorePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xpcscorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in ypcscorePopup.
%ypcscorePopup==PC Y-axes
function ypcscorePopup_Callback(hObject, eventdata, handles)
% hObject    handle to ypcscorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ypcscorePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ypcscorePopup
incoming_data_PC2=get(hObject,'Value');%Incoming data position
handles.data.PC2=incoming_data_PC2;

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ypcscorePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ypcscorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in labscorePopup.
%labscorePopup==Label
function labscorePopup_Callback(hObject, eventdata, handles)
% hObject    handle to labscorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns labscorePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from labscorePopup


incoming_data=get(hObject,'Value');%Incoming data position
string_evaluation=handles.data.new1{incoming_data};
handles.data.namePopupmenu16=string_evaluation;
if strcmp(string_evaluation,'emptylabel'),
    label={};
    handles.data.label={};
else
    label=evalin('base',string_evaluation);
    handles.data.label=label;
end

if ~isempty(handles.data.label),
    if max(size(label))~=size(handles.data.data_matrix,1) || min(size(label))~=1,
        errordlg('Label must have as many tags as number of observations in the data matrix.');
        handles.data.namePopupmenu16='emptylabel';
        handles.data.label={};
        nombres=cellstr(get(hObject,'String'));
        for i=1:length(nombres),
            if strcmp(nombres(i),'emptylabel'),
                val=i;
            end
        end
        set(hObject,'Value',val);
    end
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function labscorePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to labscorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
new1=[];
handles.data.label={};
set(hObject,'String',{'emptylabel'});

handles.data.WorkSpace=evalin('base','who');
if ~isempty(handles.data.WorkSpace),
    contents=get(hObject,'String');
    new1=[];
    for i=1:length(handles.data.WorkSpace),
        new1=[new1 handles.data.WorkSpace(i,:)];
    end
    new1=[contents,new1];
    set(hObject,'String',strvcat(new1));
end

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

nombres=cellstr(get(hObject,'String'));
for i=1:length(nombres),
    if strcmp(nombres(i),'emptylabel'),
        val=i;
    end
end

set(hObject,'Value',val);
handles.data.new1=new1;
handles.data.namePopupmenu16='emptylabel';
guidata(hObject, handles);

% --- Executes on selection change in classcorePopup.
%classcorePopup==Classes
function classcorePopup_Callback(hObject, eventdata, handles)
% hObject    handle to classcorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns classcorePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from classcorePopup


incoming_data=get(hObject,'Value');
string_evaluation=handles.data.new2{incoming_data};
handles.data.namePopupmenu15=string_evaluation;
if strcmp(string_evaluation,'emptyclasses'),
    classes=[];
    handles.data.classes=[];
else
    classes=evalin('base',string_evaluation);
    handles.data.classes=classes;
end

if ~isempty(handles.data.classes),
    if max(size(classes))~=size(handles.data.data_matrix,1) || min(size(classes))~=1,
        errordlg('Classes must have as many tags as number of observations in the data matrix.');
        handles.data.namePopupmenu15='emptyclasses';
        handles.data.classes=[];
        nombres=cellstr(get(hObject,'String'));
        for i=1:length(nombres),
            if strcmp(nombres(i),'emptyclasses'),
                val=i;
            end
        end
        set(hObject,'Value',val);
    end
end

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function classcorePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to classcorePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
new2=[];
handles.data.classes=[];
set(hObject,'String',{'emptyclasses'});

handles.data.WorkSpace=evalin('base','who');
if ~isempty(handles.data.WorkSpace),
    contents=get(hObject,'String');
    new2=[];
    for i=1:length(handles.data.WorkSpace),
        new2=[new2 handles.data.WorkSpace(i,:)];
    end
    new2=[contents,new2];
    set(hObject,'String',strvcat(new2));
end

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

nombres=cellstr(get(hObject,'String'));
for i=1:length(nombres),
    if strcmp(nombres(i),'emptyclasses'),
        val=i;
    end
end
handles.data.namePopupmenu15='emptyclasses';
set(hObject,'Value',val);
handles.data.new2=new2;
guidata(hObject, handles);

% --- Executes on button press in scoreButton.
%Pushbutton==Plot
function scoreButton_Callback(hObject, eventdata, handles)
% hObject    handle to scoreButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.PC1 = str2num(getCurrentPopupString(handles.xpcscorePopup));
handles.data.PC2 = str2num(getCurrentPopupString(handles.ypcscorePopup));

all_opened_graphs=get(0,'Children');
new_sp_ID_figures=[];
new_sp_matrix={};
clean_ind=[];

for i=1:length(handles.data.sp_ID_figures),
    if ~isempty(find(handles.data.sp_ID_figures(i)==all_opened_graphs,1)),
        new_sp_ID_figures=[new_sp_ID_figures handles.data.sp_ID_figures(i)];
        new_sp_matrix={new_sp_matrix{:} handles.data.sp_matrix{:,i}};
    else
        clean_ind=[clean_ind i];%Identificadores de lo Score Plots cerrados
        for j=1:length(clean_ind),
            aux=clean_ind(j);
            handles.data.clean_control(aux)=0;
            handles.data.CORTES{1,aux}=[];
            handles.data.weightDummy{1,aux}=[];
            handles.data.matrix_2PCs{1,aux}=[];
            %Dummy:
            M=size(handles.data.data_matrix,1);
            dummy=zeros(1,M);
            handles.data.dummy{1,aux}=dummy;
            handles.data.dummyRED=dummy;
            handles.data.dummyGREEN=dummy;
        end
    end
end

handles.data.sp_ID_figures=new_sp_ID_figures;%Vector actualizado con los identificadores de los Score Plots abiertos 
handles.data.sp_matrix=new_sp_matrix;

if isempty(handles.data.label) && isempty(handles.data.classes),
    [T,TT]=scores_pca(handles.data.data_matrix,[handles.data.PC1 handles.data.PC2],[],handles.data.prep,1);
else if ~isempty(handles.data.label) && isempty(handles.data.classes),
        [T,TT]=scores_pca(handles.data.data_matrix,[handles.data.PC1 handles.data.PC2],[],handles.data.prep,1,handles.data.label);
    else if isempty(handles.data.label) && ~isempty(handles.data.classes),
            [T,TT]=scores_pca(handles.data.data_matrix,[handles.data.PC1 handles.data.PC2],[],handles.data.prep,1,[],handles.data.classes);
        else [T,TT]=scores_pca(handles.data.data_matrix,[handles.data.PC1 handles.data.PC2],[],handles.data.prep,1,handles.data.label,handles.data.classes);
        end
    end
end
fig=gcf;
set(fig,'Tag','ScorePlot');%En la opci�n etiqueta se indica que el gr�fico es un Score Plot

matrixPCs_oMEDA=[T(:,handles.data.PC1),T(:,handles.data.PC2)];

handles.data.sp_ID_figures=[handles.data.sp_ID_figures fig];%Vector con los identificadores de los Score Plots abiertos
handles.data.sp_matrix={handles.data.sp_matrix{:} matrixPCs_oMEDA};

%oMEDA (Select)
set(handles.selomedaButton,'Enable','on');

guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%oMEDA Submenu%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in selomedaButton.
%selomedaButton==SELECT
function selomedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to selomedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ID_list=get(0,'Children');
ID=ID_list(2);%Identificador de la gr�fica seleccionada (debe ser un Score Plot).
if ~isnumeric(ID),
    ID = ID.Number;
end

check_tag=get(ID,'Tag');
if strcmp(check_tag,'ScorePlot'),
    figure(ID);%Lanzar el Score Plot seleccionado para hacer oMEDA.
else
    errordlg('To perform oMEDA you must select a Score Plot.');
    return;
end

%Es necesario recuperar los datos del Score Plot seleccionado, es decir las observaciones ploteadas en el eje x e y:
%Voy a recorrer el vector de gcfs de score plots que se llama
%handles.data.sp_ID_figures, para buscar en que posici�n est� el gcf ID.
for i=1:length(handles.data.sp_ID_figures),
    if handles.data.sp_ID_figures(i)==ID,
        % codigo de compr de que est� vacio
%         ID
%         size(handles.data.sp_matrix)
        matrix_2PCs=handles.data.sp_matrix{:,i};
    end
end

irr_pol=impoly;
vertex=getPosition(irr_pol);
N=size(vertex,1);%Tama�o de la matriz:
%filas: n�mero de v�rtices del polinomio irregular
%columnas: contiene 2 columnas: coordenada x y coordenada y de cada v�rtice.

%PASO 1:
%Calcular los par�metros A, B y C de la ecuaci�n normal de la recta, para
%todas las rectas que formen el polinomio irregular dibujado por el usuario
A=[];
B=[];
C=[];
for i=1:N,%Desde 1 hasta el n�mero de v�rtices que tenga el polinomio
    %irregular, voy a hacer lo siguiente:
    
    %Coordenadas de un v�rtice:
    x1=vertex(i,1);
    y1=vertex(i,2);
    
    %Cooredenadas del siguiente v�rtice:
    %El if controla el caso en que ya se hayan cogido todos los v�rtices,
    %el v�rtce en ese caso ser� el primero de ellos, para cerrar la figura.
    if i==N,
        x2=vertex(1,1);
        y2=vertex(1,2);
    else
        x2=vertex(i+1,1);
        y2=vertex(i+1,2);
    end
    
    %Coordenadas del vector director de la recta que une ambos v�rtices:
    u1=x2-x1;
    u2=y2-y1;
    
    A=[A,u2];%Lista de u2(segunda coordenada del vector director)
    B=[B,-u1];%Lista de u1 (primera coordenada del vector director)
    c=(u1*y1)-(u2*x1);%C�lculo del par�metro C de la ec.normal de la recta.
    C=[C,c];%Lista del par�metro C, uno por recta.
end

%PASO 2:
%Obtener los puntos de corte entre cada una de las anteriores rectas y la
%semirrecta(paralela al eje X) que forma el punto del Score matrix a estudio.
M=size(handles.data.data_matrix,1);%Number of observations in the score matrix.
X=[];
corte=0;
CORTES=[];

for j=1:M, %Se recorren todas las observaciones
    Y=matrix_2PCs(j,2);
    corte=0;
    for k=1:N,%Todas las rectas del poligono irregular
        X=(-(B(k)*Y)-C(k))/A(k);
        
        if k+1>N,
            if (Y>min(vertex(k,2),vertex(1,2)))&&(Y<max(vertex(k,2),vertex(1,2))),
                if X>matrix_2PCs(j,1),
                    corte=corte+1;
                end
            end
        else
            if (Y>min(vertex(k,2),vertex(k+1,2)))&&(Y<max(vertex(k,2),vertex(k+1,2))),
                if X>matrix_2PCs(j,1),
                    corte=corte+1;
                end
            end
        end
    end
    CORTES=[CORTES,corte];
end

set(handles.minusButton,'Enable','on');
set(handles.plusButton,'Enable','on');
set(handles.cleanButton,'Enable','on');

handles.data.CORTES{1,ID}=CORTES;
handles.data.matrix_2PCs{1,ID}=matrix_2PCs;
handles.data.clean_control(ID)=handles.data.clean_control(ID)+1;

guidata(hObject,handles);

% --- Executes on button press in minusButton.
%minusButton==- -> RED
function minusButton_Callback(hObject, eventdata, handles)
% hObject    handle to minusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ID_list=get(0,'Children');
ID=ID_list(2);%gcf del score plot que me interesa
if ~isnumeric(ID),
    ID = ID.Number;
end

check_tag=get(ID,'Tag');
if strcmp(check_tag,'ScorePlot'),
    figure(ID);%Ya tengo el score plot pinchado(al que le quiero hacer oMEDA) en primera plana.
    hold on;
else
    errordlg('To perform oMEDA you must select a Score Plot.');
    return;
end

M=size(handles.data.data_matrix,1);
CortesVector=handles.data.CORTES{1,ID};
matrix_2PCs=handles.data.matrix_2PCs{1,ID};

for l=1:M,
    if mod(CortesVector(l),2)==1,
        
        Xdata=matrix_2PCs(l,1);
        Ydata=matrix_2PCs(l,2);
        
        coord=plot(Xdata,Ydata);
        set(coord,'marker','s');
        %set(coord,'markersize',6);
        set(coord,'markerfacecolor', [0 0 0]+0.9);
        set(coord,'markeredgecolor','k');
        
        %Dummy:
        handles.data.dummyRED(l)=-1;

        handles.data.clean_control(ID)=handles.data.clean_control(ID)+1;
    end
end

handles.data.dummy{1,ID}=handles.data.dummyGREEN+handles.data.dummyRED;
set(handles.omedaButton,'Enable','on');
set(handles.trendButton,'Enable','on');
guidata(hObject,handles);

% --- Executes on button press in plusButton.
%plusButton==+ -> GREEN
function plusButton_Callback(hObject, eventdata, handles)
% hObject    handle to plusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ID_list=get(0,'Children');
ID=ID_list(2);%gcf del score plot que me interesa
if ~isnumeric(ID),
    ID = ID.Number;
end

check_tag=get(ID,'Tag');
if strcmp(check_tag,'ScorePlot'),
    figure(ID);%Ya tengo el score plot pinchado(al que le quiero hacer oMEDA) en primera plana.
    hold on;
else
    errordlg('To perform oMEDA you must select a Score Plot.');
    return;
end

M=size(handles.data.data_matrix,1);
CortesVector=handles.data.CORTES{1,ID};
matrix_2PCs=handles.data.matrix_2PCs{1,ID};

for l=1:M,
    if mod(CortesVector(l),2)==1,
        Xdata=matrix_2PCs(l,1);
        Ydata=matrix_2PCs(l,2);
        
        coord=plot(Xdata,Ydata);
        set(coord,'marker','o');
        %set(coord,'markersize',6);
        set(coord,'markerfacecolor',[0 0 0]+0.9);
        set(coord,'markeredgecolor','k');
        
        handles.data.dummyGREEN(l)=1;
        handles.data.clean_control(ID)=handles.data.clean_control(ID)+1;
    end
end

handles.data.dummy{1,ID}=handles.data.dummyGREEN+handles.data.dummyRED;
set(handles.omedaButton,'Enable','on');
set(handles.trendButton,'Enable','on');
guidata(hObject,handles);


% --- Executes on button press in trendButton.
%trendButton==TREND LINE
function trendButton_Callback(hObject, eventdata, handles)
% hObject    handle to trendButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ID_list=get(0,'Children');
ID=ID_list(2);%gcf del score plot que me interesa
if ~isnumeric(ID),
    ID = ID.Number;
end

check_tag=get(ID,'Tag');
if strcmp(check_tag,'ScorePlot'),
    figure(ID);%Ya tengo el score plot pinchado(al que le quiero hacer oMEDA) en primera plana.
    hold on;
else
    errordlg('To perform oMEDA you must select a Score Plot.');
    return;
end

matrix_2PCs=handles.data.matrix_2PCs{1,ID};
trend_line=imline;
setColor(trend_line,[0 0 0]);
vertex_line=getPosition(trend_line);

x1=vertex_line(1,1);
y1=vertex_line(1,2);
x2=vertex_line(2,1);
y2=vertex_line(2,2);

%Coordenadas del vector director de la recta que une ambos v�rtices:
u1=x2-x1;
u2=y2-y1;

%La ecuaci�n de la recta tendencia es:
A=u2;
B=-u1;
C=(u1*y1)-(u2*x1);

%Quiero el punto de corte de la tendencia con la recta que va de la observaci�n
%a la l�nea tendencia en perpendicular. Esto para cada una de las
%observaciones.
Cutoff_points=[];
M=size(handles.data.data_matrix,1);
for m=1:M,
    p1=matrix_2PCs(m,1);
    p2=matrix_2PCs(m,2);
    
    %El vector director de la recta que va de la observacion a la
    %tendencia en perpendicular es:
    v1=A;
    v2=B;
    
    %La ecuacuaci�n de la recta es:
    A2=v2;
    B2=-v1;
    C2=(v1*p2)-(v2*p1);
    
    %Ahora se obtiene el punto de corte de ambas rectas:
    %Ax+By+C=0;
    %A2x+B2y+C2=0;
    y_corte=(-C2+(A2/A)*C)/(((-A2/A)*B)+B2);
    x_corte=((-B*y_corte)-C)/A;
    Cutoff_points(m,1)=x_corte;
    Cutoff_points(m,2)=y_corte;
end
%Quedarse con la menor distancia entre un 1 y -1
lowest_dist=Inf;
ind1=1;
ind2=1;
dummy=handles.data.dummy{1,ID};
for k=1:M,
    if dummy(k)==1,
        %Coordenadas del punto que tiene asignado un 1 en la variable
        %dummy
        p1=Cutoff_points(k,1);
        p2=Cutoff_points(k,2);
        
        for l=1:M,
            if dummy(l)==-1,
                q1=Cutoff_points(l,1);
                q2=Cutoff_points(l,2);
                dist=sqrt((q1-p1)^2+(q2-p2)^2);
                if dist< lowest_dist,
                    lowest_dist=dist;
                    ind1=k;
                    ind2=l;
                end
            end
        end
        
    end
end

%Construcci�n de la nueva DUMMY con pesos:
%Calcular el punto medio entre las observaciones m�s cercanas obtenidas
%enteriormente, este ser� el nuevo cero para asignar pesos.
c1=Cutoff_points(ind1,:);
c2=Cutoff_points(ind2,:);
NewCenter=(c1+c2)/2;

%Asignaci�n de pesos
for m=1:M,
    weights(m)=sum((Cutoff_points(m,:)-NewCenter).^2);
end
weightDummy=weights.*dummy;

handles.data.weightDummy{1,ID}= weightDummy;
handles.data.clean_control(ID)=handles.data.clean_control(ID)+1;

guidata(hObject,handles);

% --- Executes on button press in cleanButton.
%cleanButton==CLEAN
function cleanButton_Callback(hObject, eventdata, handles)
% hObject    handle to cleanButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ID_list=get(0,'Children');
ID=ID_list(2);%gcf del score plot que me interesa
if ~isnumeric(ID),
    ID = ID.Number;
end

check_tag=get(ID,'Tag');
if strcmp(check_tag,'ScorePlot'),
    figure(ID);%Ya tengo el score plot pinchado(al que le quiero hacer oMEDA) en primera plana.
else
    errordlg('To clean a figure this must be a Score Plot.');
    return;
end

clean_times=handles.data.clean_control(ID);

a=get(ID,'Children');
b=a(length(a));
c=get(b,'Children');
delete(c(1:clean_times));

handles.data.clean_control(ID)=0;
handles.data.weightDummy{1,ID}=[];
%Dummy:
M=size(handles.data.data_matrix,1);
dummy=zeros(1,M);
handles.data.dummy{1,ID}=dummy;
handles.data.dummyRED=dummy;
handles.data.dummyGREEN=dummy;

guidata(hObject,handles);


% --- Executes on button press in omedaButton.
%omedaButton==Plot (oMEDA)
function omedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to omedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ID_list=get(0,'Children');
ID=ID_list(2);%gcf del score plot que me interesa
if ~isnumeric(ID),
    ID = ID.Number;
end

check_tag=get(ID,'Tag');
if strcmp(check_tag,'ScorePlot'),

else
    errordlg('To perform oMEDA you must select a Score Plot.');
    return;
end

if isequal(handles.data.dummy{1,ID},zeros(1,size(handles.data.dummy{1,ID},2))) && isempty(handles.data.weightDummy{1,ID}),
    errordlg('To perform oMEDA you must select a Score Plot with at least one object selected.');
    return;
end

if ~isempty(handles.data.weightDummy{1,ID}),
    handles.data.weightDummy{1,ID}=handles.data.weightDummy{1,ID}./abs(max(handles.data.weightDummy{1,ID}));
    omeda_pca(handles.data.data_matrix,[min(handles.data.PC1,handles.data.PC2) max(handles.data.PC1,handles.data.PC2)],handles.data.data_matrix,handles.data.weightDummy{1,ID}',handles.data.prep,1,handles.data.label_LP);
else
    omeda_pca(handles.data.data_matrix,[min(handles.data.PC1,handles.data.PC2) max(handles.data.PC1,handles.data.PC2)],handles.data.data_matrix,handles.data.dummy{1,ID}',handles.data.prep,1,handles.data.label_LP);
end

guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Residue%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in resomedaButton.
%resomedaButton==Plot(residue)
function resomedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to resomedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
E=sqresiduals_pca(handles.data.data_matrix,min(handles.data.PCs):max(handles.data.PCs),[],handles.data.prep,1,handles.data.label);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Loading Plot%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in xpcvarPopup.
%xpcvarPopup==PCs X-axes
function xpcvarPopup_Callback(hObject, eventdata, handles)
% hObject    handle to xpcvarPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns xpcvarPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from xpcvarPopup
incoming_data_PC1_LP=get(hObject,'Value');%Incoming data position
handles.data.PC1_LP=incoming_data_PC1_LP;

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function xpcvarPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xpcvarPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ypcvarPopup.
%ypcvarPopup==PCs Y-axes
function ypcvarPopup_Callback(hObject, eventdata, handles)
% hObject    handle to ypcvarPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ypcvarPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ypcvarPopup
incoming_data_PC2_LP=get(hObject,'Value');%Incoming data position
handles.data.PC2_LP=incoming_data_PC2_LP;

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function ypcvarPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ypcvarPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in labvarPopup.
%labvarPopup==Label
function labvarPopup_Callback(hObject, eventdata, handles)
% hObject    handle to labvarPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns labvarPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from labvarPopup

incoming_data=get(hObject,'Value');
string_evaluation=handles.data.new3{incoming_data};
handles.data.namePopupmenu20=string_evaluation;
if strcmp(string_evaluation,'emptylabel'),
    label_LP={};
    handles.data.label_LP={};
else
    label_LP=evalin('base',string_evaluation);
    handles.data.label_LP=label_LP;
end

if ~isempty(handles.data.label_LP),
    if max(size(label_LP))~=size(handles.data.data_matrix,2) || min(size(label_LP))~=1,
        errordlg('Label must have as many tags as number of variables in the data matrix.');
        handles.data.namePopupmenu20='emptylabel';
        handles.data.label_LP={};
        nombres=cellstr(get(hObject,'String'));
        for i=1:length(nombres),
            if strcmp(nombres(i),'emptylabel'),
                val=i;
            end
        end
        set(hObject,'Value',val);
    end
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function labvarPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to labvarPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
new3=[];
handles.data.label_LP={};
set(hObject,'String',{'emptylabel'});

handles.data.WorkSpace=evalin('base','who');%nombres de las variables
if ~isempty(handles.data.WorkSpace),
    contents=get(hObject,'String');
    new3=[];
    for i=1:length(handles.data.WorkSpace),
        new3=[new3 handles.data.WorkSpace(i,:)];
    end
    new3=[contents,new3];
    set(hObject,'String',strvcat(new3));
end

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

nombres=cellstr(get(hObject,'String'));
for i=1:length(nombres),
    if strcmp(nombres(i),'emptylabel'),
        val=i;
    end
end
handles.data.namePopupmenu20='emptylabel';
set(hObject,'Value',val);
handles.data.new3=new3;
guidata(hObject, handles);

% --- Executes on selection change in clasvarPopup.
%labvarPopup==Classes
function clasvarPopup_Callback(hObject, eventdata, handles)
% hObject    handle to clasvarPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns clasvarPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from clasvarPopup

incoming_data=get(hObject,'Value');%Incoming data position
string_evaluation=handles.data.new4{incoming_data};%Nombre correspondiente a la posici�n
handles.data.namePopupmenu19=string_evaluation;
if strcmp(string_evaluation,'emptyclasses'),
    classes_LP={};
    handles.data.classes_LP={};
else
    classes_LP=evalin('base',string_evaluation);%Contenido de ese nombre(los datos en si)
    handles.data.classes_LP=classes_LP;
end

if ~isempty(handles.data.classes_LP),
    if max(size(classes_LP))~=size(handles.data.data_matrix,2) || min(size(classes_LP))~=1,
        errordlg('Classes must have as many entries as number of variables in the data matrix.');
        handles.data.namePopupmenu19='emptyclasses';
        handles.data.classes_LP=[];
        nombres=cellstr(get(hObject,'String'));
        for i=1:length(nombres),
            if strcmp(nombres(i),'emptyclasses'),
                val=i;
            end
        end
        set(hObject,'Value',val);
    end
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function clasvarPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clasvarPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
new4=[];
handles.data.classes_LP=[];
set(hObject,'String',{'emptyclasses'});

handles.data.WorkSpace=evalin('base','who');%nombres de las variables
if ~isempty(handles.data.WorkSpace),
    contents=get(hObject,'String');
    new4=[];
    for i=1:length(handles.data.WorkSpace),
        new4=[new4 handles.data.WorkSpace(i,:)];
    end
    new4=[contents,new4];
    set(hObject,'String',strvcat(new4));
end

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

nombres=cellstr(get(hObject,'String'));
for i=1:length(nombres),
    if strcmp(nombres(i),'emptyclasses'),
        val=i;
    end
end
handles.data.namePopupmenu19='emptyclasses';
set(hObject,'Value',val);
handles.data.new4=new4;
guidata(hObject, handles);


% --- Executes on button press in medaButton.
%medaButton==Plot (loading plot)
function loadingButton_Callback(hObject, eventdata, handles)
% hObject    handle to medaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.PC1_LP=str2num(getCurrentPopupString(handles.xpcvarPopup));
handles.data.PC2_LP=str2num(getCurrentPopupString(handles.ypcvarPopup));

all_opened_graphs=get(0,'Children');
new_lp_ID_figures=[];
new_lp_matrix={};

for i=1:length(handles.data.lp_ID_figures),
    if ~isempty(find(handles.data.lp_ID_figures(i)==all_opened_graphs,1)),
        new_lp_ID_figures=[new_lp_ID_figures handles.data.lp_ID_figures(i)];
        new_lp_matrix={new_lp_matrix{:} handles.data.lp_matrix{:,i}};
    end
end

handles.data.lp_ID_figures=new_lp_ID_figures;%Identificadores de los Loadings Plots abiertos actualizado
handles.data.lp_matrix=new_lp_matrix;

if isempty(handles.data.label_LP) && isempty(handles.data.classes_LP),
    P = loadings_pca (handles.data.data_matrix, [handles.data.PC1_LP handles.data.PC2_LP], handles.data.prep, 1);
else if ~isempty(handles.data.label_LP) && isempty(handles.data.classes_LP),
        P = loadings_pca (handles.data.data_matrix, [handles.data.PC1_LP handles.data.PC2_LP], handles.data.prep, 1, handles.data.label_LP);
    else if isempty(handles.data.label_LP) && ~isempty(handles.data.classes_LP),
            P = loadings_pca (handles.data.data_matrix, [handles.data.PC1_LP handles.data.PC2_LP], handles.data.prep, 1, [], handles.data.classes_LP);
        else P = loadings_pca (handles.data.data_matrix, [handles.data.PC1_LP handles.data.PC2_LP], handles.data.prep, 1, handles.data.label_LP, handles.data.classes_LP);
        end
    end
end
fig=gcf;
set(fig,'Tag','LoadingPlot');%A cada LoadingPlot que abro le pongo en su propiedad 'Tag' que es un LoadingPlot

matrixPCs_MEDA_LP=[P(:,handles.data.PC1_LP),P(:,handles.data.PC2_LP)];

handles.data.lp_ID_figures=[handles.data.lp_ID_figures fig];%Identificadores de los Score Plots abiertos
handles.data.lp_matrix={handles.data.lp_matrix{:} matrixPCs_MEDA_LP};

set(handles.selmedaButton,'Enable','on');

guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MEDA Submenu%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%thresEdit==thresold
function thresEdit_Callback(hObject, eventdata, handles)
% hObject    handle to thresEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresEdit as text
%        str2double(get(hObject,'String')) returns contents of thresEdit as a double
thres=str2double(get(hObject,'String'));
handles.data.thres = thres;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function thresEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', 0.1);
thresEdit_Callback(hObject, eventdata, handles);

% --- Executes on button press in thresRadio.
%thresRadio==thresold
function thresRadio_Callback(hObject, eventdata, handles)
% hObject    handle to thresRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of thresRadio
%Si radio button se�alado q ecit 6 este ON si no se�alado q este OFF
if get(handles.thresRadio, 'Value'),
    set(handles.thresEdit, 'Enable', 'on');
    set(handles.text5, 'Enable', 'on');
else
    set(handles.thresEdit, 'Enable', 'off');
    set(handles.text5, 'Enable', 'off');
end

guidata(hObject,handles);


% --- Executes on button press in serRadio.
%thresRadio==seriation
function serRadio_Callback(hObject, eventdata, handles)
% hObject    handle to serRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of serRadio


% --- Executes on selection change in medaPopup.
%medaPopup==MEDA popupmenu
function medaPopup_Callback(hObject, eventdata, handles)
% hObject    handle to medaPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns medaPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from medaPopup

PCs_MEDA_position=get(hObject,'Value');%Incoming data position
contents=get(hObject,'String');
PCs_MEDA=contents(PCs_MEDA_position,:);%Nombre correspondiente a la posición

handles.data.PCs_MEDA=PCs_MEDA;

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function medaPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to medaPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in medaButton.
%medaButton==Plot (MEDA)
function medaButton_Callback(hObject, eventdata, handles)
% hObject    handle to medaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.PCs_MEDA=getCurrentPopupString(handles.medaPopup);
PCs_MEDA_cell = strread(handles.data.PCs_MEDA,'%s','delimiter',':');
pcs = [str2num(PCs_MEDA_cell{1}):str2num(PCs_MEDA_cell{2})];
if get(handles.thresRadio,'Value')==1 && get(handles.serRadio,'Value')==0,
    handles.data.opt=2;
else if get(handles.thresRadio,'Value')==0 && get(handles.serRadio,'Value')==1,
        handles.data.opt=3;
    else if get(handles.serRadio,'Value')==0 && get(handles.serRadio,'Value')==0,
            handles.data.opt=1;
        else handles.data.opt=4;
        end
    end
end

[meda_map,meda_dis]=meda_pca(handles.data.data_matrix,pcs,handles.data.prep,handles.data.thres,handles.data.opt,handles.data.label_LP);

guidata(hObject,handles);

% --- Executes on button press in selmedaButton.
%selmedaButton==Select (MEDA)
function selmedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to selmedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ID_list=get(0,'Children');
ID=ID_list(2);%gcf del score plot que me interesa
if ~isnumeric(ID),
    ID = ID.Number;
end

check_tag=get(ID,'Tag');
if strcmp(check_tag,'LoadingPlot'),
    figure(ID);%Ya tengo el score plot pinchado(al que le quiero hacer oMEDA) en primera plana.
else
    errordlg('To perform MEDA over a Loading Plot you must select one loading plot.');
    return;
end

%Ahora vamos a recuperar su matriz:
%Voy a recorrer el vector de gcfs de score plots
%handles.data.sp_ID_figures, para buscar en que posici�n esta el gcf ID.
for i=1:length(handles.data.lp_ID_figures),
    if handles.data.lp_ID_figures(i)==ID,
        matrix_2PCs=handles.data.lp_matrix{:,i};
    end
end

irr_pol=impoly;
vertex=getPosition(irr_pol);
N=size(vertex,1);%Matrix size:
%rows: number of vertex in the irregular polynomial
%columns: this matrix contains always 2 colomns: one for the X
%coordinate and the other one for the Y coordinate of each
%vertex.

%PASO 1:
%Calcular los par�metros A, B y C de la ecuaci�n normal de la recta, para
%todas las rectas que formen el polinomio irregular dibujado por el usuario
A=[];
B=[];
C=[];
for i=1:N,%Desde 1 hasta el n�mero de v�rtices que tenga el polinomio
    %irregular, voy a hacer lo siguiente:
    
    %Coordenadas de un v�rtice
    x1=vertex(i,1);
    y1=vertex(i,2);
    
    %Cooredenadas del siguiente v�rtice:
    %El if controla el caso en que ya se hayan cogido todos los v�rtices,
    %el v�rtce en ese caso ser� el primero de ellos, para cerrar la figura.
    if i==N,
        x2=vertex(1,1);
        y2=vertex(1,2);
    else
        x2=vertex(i+1,1);
        y2=vertex(i+1,2);
    end
    
    %Coordenadas del vector director de la recta que une ambos v�rtices:
    u1=x2-x1;
    u2=y2-y1;
    
    A=[A,u2];%Lista de u2(segunda coordenada del vector director)
    B=[B,-u1];%Lista de u1 (primera coordenada del vector director)
    c=(u1*y1)-(u2*x1);%C�lculo del par�metro C de la ec.normal de la recta.
    C=[C,c];%Lista del par�metro C, uno por recta.
end

%PASO 2:
%Obtener los puntos de corte entre cada una de las anteriores rectas y la
%semirrecta(paralela al eje X) que forma el punto del Score matrix a estudio.
M=size(handles.data.data_matrix,2);%Number of observations in the score matrix.
X=[];
corte=0;
CORTES=[];

for j=1:M, %All the observations from the Score Matrix: t
    Y=matrix_2PCs(j,2);
    corte=0;
    for k=1:N,%Todas las rectas del poligono irregular
        X=(-(B(k)*Y)-C(k))/A(k);
        
        if k+1>N,
            if (Y>min(vertex(k,2),vertex(1,2)))&&(Y<max(vertex(k,2),vertex(1,2))),
                if X>matrix_2PCs(j,1),
                    corte=corte+1;
                end
            end
        else
            if (Y>min(vertex(k,2),vertex(k+1,2)))&&(Y<max(vertex(k,2),vertex(k+1,2))),
                if X>matrix_2PCs(j,1),
                    corte=corte+1;
                end
            end
        end
    end
    CORTES=[CORTES,corte];
end

CortesVector=CORTES;
vector_vars=[];
for l=1:M,
    if mod(CortesVector(l),2)==1,
        Xdata=matrix_2PCs(l,1);
        Ydata=matrix_2PCs(l,2);
        
        coord=plot(Xdata,Ydata);
        set(coord,'marker','o');
        set(coord,'markersize',6);
        set(coord,'markerfacecolor','b');
        set(coord,'markeredgecolor','b');
        
        vector_vars=[vector_vars l];
    end
end

if get(handles.thresRadio,'Value')==1 && get(handles.serRadio,'Value')==0,
    handles.data.opt=2;
else if get(handles.thresRadio,'Value')==0 && get(handles.serRadio,'Value')==1,
        handles.data.opt=3;
    else if get(handles.serRadio,'Value')==0 && get(handles.serRadio,'Value')==0,
            handles.data.opt=1;
        else handles.data.opt=4;
        end
    end
end

[meda_map,meda_dis]=meda_pca(handles.data.data_matrix,[min(handles.data.PC1_LP,handles.data.PC2_LP) max(handles.data.PC1_LP,handles.data.PC2_LP)],handles.data.prep,handles.data.thres,handles.data.opt,handles.data.label_LP,vector_vars);

guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Residue%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in resvarButton.
%resvarButton==Plot (residue)
function resvarButton_Callback(hObject, eventdata, handles)
% hObject    handle to resvarButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
E=sqresiduals_pca(handles.data.data_matrix,min(handles.data.PCs):max(handles.data.PCs),[],handles.data.prep,2,handles.data.label_LP);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%Information panel%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%infoText==Static text-Information panel
% --- Executes during object creation, after setting all properties.
function infoText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to infoText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in modelomedaButton.
function modelomedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to modelomedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
E=leverage_pca(handles.data.data_matrix,min(handles.data.PCs):max(handles.data.PCs),[],handles.data.prep,1,handles.data.label);


% --- Executes on button press in modelmedaButton.
function modelmedaButton_Callback(hObject, eventdata, handles)
% hObject    handle to modelmedaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
E=leverage_pca(handles.data.data_matrix,min(handles.data.PCs):max(handles.data.PCs),[],handles.data.prep,2,handles.data.label_LP);


% --- Executes on button press in nextButton.
function nextButton_Callback(hObject, eventdata, handles)
% hObject    handle to nextButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.data.messageNum < handles.data.messageNum_max
    handles.data.messageNum = handles.data.messageNum +1;
    information_message(handles);
end
guidata(hObject,handles);

% --- Executes on button press in prevButton.
function prevButton_Callback(hObject, eventdata, handles)
% hObject    handle to prevButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.data.messageNum > 0
    handles.data.messageNum = handles.data.messageNum -1;
    information_message(handles);
end
guidata(hObject,handles);

% --- Executes on button press in crossButton.
function crossButton_Callback(hObject, eventdata, handles)
% hObject    handle to crossButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in sviButton.
function sviButton_Callback(hObject, eventdata, handles)
% hObject    handle to sviButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function generalEdit_Callback(hObject, eventdata, handles)
% hObject    handle to generalEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of generalEdit as text
%        str2double(get(hObject,'String')) returns contents of generalEdit as a double


% --- Executes during object creation, after setting all properties.
function generalEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to generalEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in generalPopup.
function generalPopup_Callback(hObject, eventdata, handles)
% hObject    handle to generalPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns generalPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from generalPopup

generalSelection = getCurrentPopupString(hObject);

switch generalSelection
    case 'SVI plot'
        set(handles.selectText,'Enable','on');
        set(handles.selectPopup,'Enable','on');
    otherwise
        set(handles.selectText,'Enable','off');
        set(handles.selectPopup,'Enable','off');
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function generalPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to generalPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in selectPopup.
function selectPopup_Callback(hObject, eventdata, handles)
% hObject    handle to selectPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectPopup


% --- Executes during object creation, after setting all properties.
function selectPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

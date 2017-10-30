function varargout = CellSpark(varargin)
global State currents
% CELLSPARK MATLAB code for CellSpark.fig
%      CELLSPARK, by itself, creates a new CELLSPARK or raises the existing
%      singleton*.
%
%      H = CELLSPARK returns the handle to a new CELLSPARK or the handle to
%      the existing singleton*.
%
%      CELLSPARK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CELLSPARK.M with the given input arguments.
%
%      CELLSPARK('Property','Value',...) creates a new CELLSPARK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CellSpark_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CellSpark_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CellSpark

% Last Modified by GUIDE v2.5 24-Sep-2017 19:14:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @CellSpark_OpeningFcn, ...
    'gui_OutputFcn',  @CellSpark_OutputFcn, ...
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


% --- Executes just before CellSpark is made visible.
function CellSpark_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CellSpark (see VARARGIN)
handles.count = 0;
handles.labels={};
%handles.P = plot(handles.axes1,0,0,'k');
xlim([0,600])
ylim([-100,80])
grid minor
datacursormode on
hold on
setappdata(0,'HT',0.02);
setappdata(0,'STOPTIME',600);
setappdata(0,'bcl',1000);
setappdata(0,'protocol', 'DYNREST');
pushbutton3_Callback(hObject,eventdata,handles);
% Choose default command line output for CellSpark
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CellSpark wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CellSpark_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
type = find([get(handles.radiobutton1,'Value'),get(handles.radiobutton2,'Value'),get(handles.radiobutton3,'Value'),get(handles.radiobutton7,'Value')]);
switch type
    case 1
        Args.type = 'EPI';
    case 2
        Args.type = 'ENDO';
    case 3
        Args.type = 'MCELL';
    case 4
        Args.type = 'NEURON';
end

Args.Ko = str2double(get(handles.edit1,'String'));
Args.Cao = str2double(get(handles.edit2, 'String'));
Args.Nao = str2double(get(handles.edit3, 'String'));
Args.Tc = str2double(get(handles.edit4, 'String'));
Args.Ki = str2double(get(handles.edit5, 'String'));
Args.Cai = str2double(get(handles.edit6, 'String'));
Args.Nai = str2double(get(handles.edit7, 'String'));
Args.Cm = str2double(get(handles.edit8, 'String'));
Args.Vc = str2double(get(handles.edit13, 'String'));
Args.Vsr = str2double(get(handles.edit14, 'String'));
Args.amp = str2double(get(handles.edit9, 'String'));
Args.dur = str2double(get(handles.edit10, 'String'));
Args.tbegin = str2double(get(handles.edit11, 'String'));
Args.ow = get(handles.checkbox1,'Value');
Args.HT = getappdata(0,'HT');
Args.STOPTIME = getappdata(0,'STOPTIME');
Args.bcl = getappdata(0,'bcl');
Args.protocol = getappdata(0,'protocol');
xlim([0,getappdata(0,'STOPTIME')]);
[hObject,handles] = run_simulation(Args,hObject,handles);
guidata(hObject,handles);


function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double
if isempty(str2num(get(hObject,'String')))
    set(hObject,'String','50');
end
set(hObject,'String',sprintf('%d',round(str2num(get(hObject,'String')))));

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double
if isempty(str2num(get(hObject,'String')))
    set(hObject,'String','1');
end
set(hObject,'String',sprintf('%d',round(str2num(get(hObject,'String')))));

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
if isempty(str2num(get(hObject,'String')))
    set(hObject,'String','52');
end
set(hObject,'String',sprintf('%0.1f',str2num(get(hObject,'String'))));

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
if isempty(str2num(get(hObject,'String')))
    set(hObject,'String','0.185');
end
set(hObject,'String',sprintf('%0.3f',str2num(get(hObject,'String'))));

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
if isempty(str2num(get(hObject,'String')))
    set(hObject,'String','11.6');
end
set(hObject,'String',sprintf('%0.1f',str2num(get(hObject,'String'))));

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
if isempty(str2num(get(hObject,'String')))
    set(hObject,'String','0.2');
end
set(hObject,'String',sprintf('%0.5f',str2num(get(hObject,'String'))));

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
if isempty(str2num(get(hObject,'String')))
    set(hObject,'String','138.8');
end
set(hObject,'String',sprintf('%0.1f',str2num(get(hObject,'String'))));

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double
if isempty(str2num(get(hObject,'String')))
    set(hObject,'String','0.0164');
end
set(hObject,'String',sprintf('%0.4f',str2num(get(hObject,'String'))));

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double
if isempty(str2num(get(hObject,'String')))
    set(hObject,'String','0.0011');
end
set(hObject,'String',sprintf('%0.4f',str2num(get(hObject,'String'))));

% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
if isempty(str2num(get(hObject,'String')))
    set(hObject,'String','5.4');
end
set(hObject,'String',sprintf('%0.1f',str2num(get(hObject,'String'))));


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
if isempty(str2num(get(hObject,'String')))
    set(hObject,'String','2.0');
end
set(hObject,'String',sprintf('%0.1f',str2num(get(hObject,'String'))));

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
if isempty(str2num(get(hObject,'String')))
    set(hObject,'String','140.0');
end
set(hObject,'String',sprintf('%0.1f',str2num(get(hObject,'String'))));

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
if isempty(str2num(get(hObject,'String')))
    set(hObject,'String','37.0');
end
set(hObject,'String',sprintf('%0.1f',str2num(get(hObject,'String'))));

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
set(handles.edit2,'String','2.0');
set(handles.text17,'String','CaSR');
set(handles.edit6,'String','0.2');
set(handles.text32,'Visible','on');
set(handles.edit14,'Visible','on');
set(handles.text31,'Visible','on');
set(handles.text29,'Visible','on');
set(handles.text30,'Visible','on');
set(handles.edit13,'Visible','on');
set(handles.edit4,'String','37.0');
set(handles.text23,'String','mA');
setappdata(0,'STOPTIME',600);
setappdata(0,'HT',.02);
s={'Nao','Ko','Cao','T','Nai','Ki','CaSR','Cm','Vc','Vsr','Amplitude','Duration','Start Time'};
set(handles.popupmenu2,'String',s);
s = {'Voltage (mV)','Cai (mM)','INa (mA)','ICaL (mA)','Ito (mA)','IKs (mA)',...
    'IKr (mA)','IK1 (mA)','INaCa (mA)','INaK (mA)','IbNa (mA)','IbCa (mA)','Irel (mA)'};
set(handles.popupmenu3,'String',s);
pushbutton2_Callback(hObject,eventdata,handles);
pushbutton3_Callback(hObject,eventdata, handles);  



% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
set(handles.edit2,'String','2.0');
set(handles.text17,'String','CaSR');
set(handles.edit6,'String','0.2');
set(handles.text32,'Visible','on');
set(handles.edit14,'Visible','on');
set(handles.text31,'Visible','on');

set(handles.text29,'Visible','on');
set(handles.text30,'Visible','on');
set(handles.edit13,'Visible','on');
set(handles.edit4,'String','37.0');
set(handles.text23,'String','mA');

setappdata(0,'STOPTIME',600);
setappdata(0,'HT',.02);
s={'Nao','Ko','Cao','T','Nai','Ki','CaSR','Cm','Vc','Vsr','Amplitude','Duration','Start Time'};
set(handles.popupmenu2,'String',s);
s = {'Voltage (mV)','Cai (mM)','INa (mA)','ICaL (mA)','Ito (mA)','IKs (mA)',...
    'IKr (mA)','IK1 (mA)','INaCa (mA)','INaK (mA)','IbNa (mA)','IbCa (mA)','Irel (mA)'};
set(handles.popupmenu3,'String',s);
pushbutton2_Callback(hObject,eventdata,handles);
pushbutton3_Callback(hObject,eventdata, handles);  

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
set(handles.edit2,'String','2.0');
set(handles.text17,'String','CaSR');
set(handles.edit6,'String','0.2');
set(handles.text32,'Visible','on');
set(handles.edit14,'Visible','on');
set(handles.text31,'Visible','on');

set(handles.text29,'Visible','on');
set(handles.text30,'Visible','on');
set(handles.edit13,'Visible','on');
set(handles.edit4,'String','37.0');
set(handles.text23,'String','mA');

setappdata(0,'STOPTIME',600);
setappdata(0,'HT',.02);
s={'Nao','Ko','Cao','T','Nai','Ki','CaSR','Cm','Vc','Vsr','Amplitude','Duration','Start Time'};
set(handles.popupmenu2,'String',s);
s = {'Voltage (mV)','Cai (mM)','INa (mA)','ICaL (mA)','Ito (mA)','IKs (mA)',...
    'IKr (mA)','IK1 (mA)','INaCa (mA)','INaK (mA)','IbNa (mA)','IbCa (mA)','Irel (mA)'};
set(handles.popupmenu3,'String',s);
pushbutton2_Callback(hObject,eventdata,handles);
pushbutton3_Callback(hObject,eventdata, handles);  


% --- Executes during object creation, after setting all properties.
function uibuttongroup2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.count = 1;

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1);
handles.labels = {};
handles.count = 0;
legend(handles.axes1,'off');
guidata(hObject,handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit4,'String','37.0');
if get(handles.radiobutton7,'Value') == 1
    set(handles.edit1,'String','4.0');
    set(handles.edit2,'String','41.0');
    set(handles.edit3,'String','142.0');
    set(handles.edit5,'String','120.0');
    set(handles.edit7,'String','10.0');
    set(handles.edit6,'String','0.00011');
    set(handles.edit11,'String','1.0');
    set(handles.edit9,'String','15');
    set(handles.edit8,'String','1.0');
else
    set(handles.edit1,'String','5.4');
    set(handles.edit2, 'String','2.0');
    set(handles.edit3, 'String','140.0');
    set(handles.edit4, 'String','37.0');
    set(handles.edit5, 'String','138.8');
    set(handles.edit6, 'String','0.2');
    set(handles.edit7, 'String','11.6');
    set(handles.edit8, 'String','0.185');
    set(handles.edit13, 'String','0.0164');
    set(handles.edit14, 'String','0.0011');
    set(handles.edit9, 'String','52');
    set(handles.edit10, 'String','1');
    set(handles.edit11, 'String','50');
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',['Legend Parameter';'Ko';'Cao';'Nao';'T';'Ki';'CaSR';'Nai';'Cm';'Vc';'Vsr';'Amplitude';'Duration';'Start Time']);
guidata(hObject,handles);


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1);
handles.labels = {};
handles.count = 0;
legend(handles.axes1,'off');
guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1);
handles.labels = {};
handles.count = 0;
legend(handles.axes1,'off');
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
advsettings();


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4

zoom off
pan off
datacursormode on


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5

pan off
datacursormode off
zoom on


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6

datacursormode off
zoom off
pan on


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
reset(handles.axes1);
grid minor
datacursormode on
set(handles.radiobutton4,'Value',1);
set(handles.radiobutton5,'Value',0);
set(handles.radiobutton6,'Value',0);
xlim([0,getappdata(0,'STOPTIME')]);


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7
set(handles.edit1,'String','20.11');
set(handles.edit2,'String','44.0');
set(handles.edit3,'String','491.0');
set(handles.edit5,'String','400.0');
set(handles.edit7,'String','50,0');
set(handles.text17,'String','Cai');
set(handles.edit6,'String','0.1');
set(handles.text32,'Visible','off');
set(handles.edit14,'Visible','off');
set(handles.text31,'Visible','off');
set(handles.text29,'Visible','off');
set(handles.text30,'Visible','off');
set(handles.edit13,'Visible','off');
set(handles.edit9,'String','15');
set(handles.text23,'String','uA');

set(handles.edit4,'String','37.0');
setappdata(0,'STOPTIME',20);
setappdata(0,'HT',.001);
pushbutton2_Callback(hObject,eventdata,handles);
pushbutton3_Callback(hObject,eventdata,handles);
s={'Nao','Ko','Cao','T','Nai','Ki','Cai','Cm','Amplitude','Duration','Start Time'};
set(handles.popupmenu2,'String',s);

s = {'Voltage (mV)','INa (mA)','IK (mA)','Ileak (mA)','m','h','n'};
set(handles.popupmenu3,'String',s);

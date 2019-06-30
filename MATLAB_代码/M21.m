% 班级：16171046，姓名：谢思涵
function varargout = M21(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @M21_OpeningFcn, ...
                   'gui_OutputFcn',  @M21_OutputFcn, ...
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

function M21_OpeningFcn(hObject, eventdata, handles, varargin)
% 初始化函数

% 产生数据集
handles.peaks=peaks(35);
handles.membrane=membrane;
[x,y] = meshgrid(-8:.5:8);
r = sqrt(x.^2+y.^2) + eps;
sinc = sin(r)./r;
handles.sinc = sinc;
handles.current_data = handles.peaks;
% 绘制默认数据
surf(handles.current_data);
handles.output = hObject;
guidata(hObject, handles);

function varargout = M21_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function surfbutton_Callback(hObject, eventdata, handles)
% surf按钮响应
% 绘制图表
surf(handles.current_data);

function meshbutton_Callback(hObject, eventdata, handles)
% mesh按钮响应
% 绘制图表
mesh(handles.current_data);

function contourbutton_Callback(hObject, eventdata, handles)
% contour按钮响应
% 绘制图表
contour(handles.current_data);

function popup_menu_Callback(hObject, eventdata, handles)
% 下拉框响应

% 获取选取值
str = get(hObject, 'String');
val = get(hObject,'Value');
% 切换数据集
switch str{val};
case 'Peaks' % 使用Peaks
   handles.current_data = handles.peaks;
case 'Membrane' % 使用Membrane
   handles.current_data = handles.membrane;
case 'Sinc' % 使用Sinc
   handles.current_data = handles.sinc;
end
% 绘制图表
surf(handles.current_data);
guidata(hObject,handles);

function popup_menu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

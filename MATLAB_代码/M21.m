% �༶��16171046��������л˼��
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
% ��ʼ������

% �������ݼ�
handles.peaks=peaks(35);
handles.membrane=membrane;
[x,y] = meshgrid(-8:.5:8);
r = sqrt(x.^2+y.^2) + eps;
sinc = sin(r)./r;
handles.sinc = sinc;
handles.current_data = handles.peaks;
% ����Ĭ������
surf(handles.current_data);
handles.output = hObject;
guidata(hObject, handles);

function varargout = M21_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function surfbutton_Callback(hObject, eventdata, handles)
% surf��ť��Ӧ
% ����ͼ��
surf(handles.current_data);

function meshbutton_Callback(hObject, eventdata, handles)
% mesh��ť��Ӧ
% ����ͼ��
mesh(handles.current_data);

function contourbutton_Callback(hObject, eventdata, handles)
% contour��ť��Ӧ
% ����ͼ��
contour(handles.current_data);

function popup_menu_Callback(hObject, eventdata, handles)
% ��������Ӧ

% ��ȡѡȡֵ
str = get(hObject, 'String');
val = get(hObject,'Value');
% �л����ݼ�
switch str{val};
case 'Peaks' % ʹ��Peaks
   handles.current_data = handles.peaks;
case 'Membrane' % ʹ��Membrane
   handles.current_data = handles.membrane;
case 'Sinc' % ʹ��Sinc
   handles.current_data = handles.sinc;
end
% ����ͼ��
surf(handles.current_data);
guidata(hObject,handles);

function popup_menu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

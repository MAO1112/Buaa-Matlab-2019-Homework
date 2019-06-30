% 班级：16171046，姓名：谢思涵
function M0
    cell_list = [
        {'生命游戏' @cell_life_init  @cell_life_run  'life' }
        {'表面张力' @cell_surf_init  @cell_surf_run  'surf' }
        {'森林火灾' @cell_tree_init  @cell_tree_run  'tree' }
        {'激发介质' @cell_heart_init @cell_heart_run 'heart'}
        {'快速生长' @cell_seed_init  @cell_seed_run  'seed' }
        {'无限波浪' @cell_brain_init @cell_brain_run 'brain'}
        {'渗流集群' @cell_flow_init  @cell_flow_run  'flow' }
        {'气体动力' @cell_gas_init   @cell_gas_run   'gas'  }
        {'雪花聚集' @cell_snow_init  @cell_snow_run  'snow' }
        {'沙漏模拟' @cell_sand_init  @cell_sand_run  'sand' }
    ];
    cell_data = struct( ...
        'common', struct( ...
            'w', 200, ...
            'wall', 0, ...
            'wall_w', 2, ...
            'step', 2:2:199 ...
        ), ...
        'life', struct( ...
            'color', struct( ... %颜色方案
                'dead', 8, ...
                'live', 7, ...
                'wall', 3 ...
            ), ...
            'pinit', 5e-1 ... %初始分布概率
        ), ...
        'surf', struct( ...
            'color', struct( ... %颜色方案
                'dead', 7, ...
                'live', 4, ...
                'wall', 8 ...
            ), ...
            'pinit', 5e-1 ... %初始分布概率
        ), ...
        'tree', struct( ...
            'color', struct( ... %颜色方案
                'empty', 7, ...
                'fire', 1, ...
                'tree', 2, ...
                'wall', 8 ...
            ), ...
            'pfire', 5e-6, ... %树着火概率
            'pgrow', 1e-2 ... %空地长树概率
        ), ...
        'heart', struct( ...
            'color', struct( ... %颜色方案
                'dead', 8, ...
                'live', 6, ...
                'wall', 7 ...
            ), ...
            'pinit', 4e-2, ... %初始分布概率
            'tlevel', 6, ... %过激发层级 5 6 7是完全不同的图案
            'tmax', 10 ... %最大激发层级
        ), ...
        'seed', struct( ...
            'color', struct( ... %颜色方案
                'dead', 8, ...
                'live', 5, ...
                'wall', 7 ...
            ), ...
            'pinit', 3e-3 ... %初始分布概率
        ), ...
        'brain', struct( ...
            'color', struct( ... %颜色方案
                'dead', 8, ...
                'dying', 6, ...
                'live', 7, ...
                'wall', 2 ...
            ), ...
            'pinit', 3e-3 ... %初始分布概率
        ), ...
        'flow', struct( ...
            'color', struct( ... %颜色方案
                'dead', 8, ...
                'live', [6 5 3 4 2 1], ...
                'wall', 7 ...
            ), ...
            'pinit', 5e-5, ... %初始分布概率
            'ccolor', 3, ... %初始颜色数量
            'pflow', 5e-2 ... %渗流概率
        ), ...
        'gas', struct( ...
            'color', struct( ... %颜色方案
                'empty', 8, ...
                'gas', 3, ...
                'wall', 6 ...
            ), ...
            'pinit', 4e-1 ... %初始分布概率
        ), ...
        'snow', struct( ...
            'color', struct( ... %颜色方案
                'empty', 8, ...
                'steam', 4, ...
                'snow', 6 ...
            ), ...
            'pinit', 1e-1 ... %初始分布概率
        ), ...
        'sand', struct( ...
            'color', struct( ... %颜色方案
                'empty', 4, ...
                'sand', 3, ...
                'wall', 8 ...
            ), ...
            'pshake', 5e-2, ... %晃动震荡概率
            'pstick', 5e-1 ... %粘滞下落概率
        ) ...
    );
    %构建所有组件
    hfig = figure( ...
        'Units', 'pixels', ...
        'Name', '元胞自动机', ...
        'Visible', 'off', ...
        'Position', [0, 0, 1000, 700], ...
        'Resize', 'off', ...
        'NumberTitle', 'off' ...
    ); %窗口
    axes( ...
        'Units', 'pixels', ...
        'Position', [50, 50, 600, 600] ...
    ); %图形区域
    htime = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'text', ...
        'FontSize', 12, ...
        'String', '运行时长：    0', ...
        'Value', 0, ...
        'Position', [650, 630, 350, 25] ...
    ); %运行时长文本
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'text', ...
        'FontSize', 12, ...
        'String', '选择自动机规则', ...
        'Position', [650, 600, 350, 25] ...
    ); %文本提示
    hpopup = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'popupmenu', ...
        'FontSize', 12, ...
        'String', '下拉菜单', ...
        'Value', 1, ...
        'Position', [700, 575, 100, 25], ...
        'Callback', @popup_Callback ...
    ); %下拉框
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'pushbutton', ...
        'FontSize', 12, ...
        'String', '重新开始', ...
        'Position', [700, 530, 100, 25], ...
        'Callback', @restart_Callback ...
    ); %restart重启按钮
    hpause = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'togglebutton', ...
        'FontSize', 12, ...
        'String', '暂停', ...
        'Position', [700, 490, 100, 25], ...
        'Callback', @pause_Callback ...
    ); %pause暂停按钮
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'pushbutton', ...
        'FontSize', 12, ...
        'String', '下一步', ...
        'Position', [700, 450, 100, 25], ...
        'Callback', @next_Callback ...
    ); %next下一步按钮
    htext = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'text', ...
        'FontSize', 12, ...
        'Value', 0, ...
        'String', '元胞宽度：0', ...
        'Position', [700, 410, 200, 25] ...
    ); %width文字
    hfix = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'checkbox', ...
        'String', '宽度取整', ...
        'FontSize', 12, ...
        'Value', 1, ...
        'Position', [700, 360, 100, 25], ...
        'Callback', {@width_Callback, htext} ...
    ); %width-fix取整框
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'slider', ...
        'Max', 600, ...
        'Min', 30, ...
        'Value', 200, ...
        'SliderStep', [0.00175 0.0877], ...
        'FontSize', 12, ...
        'Position', [700, 385, 200, 25], ...
        'CreateFcn', {@width_Callback, htext, hfix}, ...
        'Callback', {@width_Callback, htext, hfix} ...
    ); %width拖动条
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'togglebutton', ...
        'FontSize', 12, ...
        'String', '重置参数', ...
        'Position', [700, 300, 100, 25], ...
        'Callback', @reset_Callback ...
    ); %reset按钮
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'togglebutton', ...
        'FontSize', 12, ...
        'String', '添加边界', ...
        'Position', [700, 260, 100, 25], ...
        'Tag', 'life tree surf heart seed brain flow', ...
        'Callback', @wall_Callback ...
    ); %wall按钮
    %life部分
    htext = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'text', ...
        'FontSize', 12, ...
        'String', '初始分布：0', ...
        'Tag', 'life', ...
        'Position', [700, 220, 200, 25] ...
    ); %初始分布文字
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'slider', ...
        'FontSize', 12, ...
        'Value', 0.5, ...
        'Position', [700, 195, 200, 25], ...
        'Tag', 'life', ...
        'Callback', {@life_pinit_Callback, htext} ...
    ); %初始分布
    %surf部分
    htext = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'text', ...
        'FontSize', 12, ...
        'String', '初始分布：0', ...
        'Tag', 'surf', ...
        'Position', [700, 220, 200, 25] ...
    ); %初始分布文字
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'slider', ...
        'FontSize', 12, ...
        'Value', 0.5, ...
        'Position', [700, 195, 200, 25], ...
        'Tag', 'surf', ...
        'Callback', {@surf_pinit_Callback, htext} ...
    ); %初始分布
    %tree部分
    htext = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'text', ...
        'FontSize', 12, ...
        'String', '生长概率：0', ...
        'Tag', 'tree', ...
        'Position', [700, 220, 200, 25] ...
    ); %生长概率文字
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'slider', ...
        'FontSize', 12, ...
        'Value', 0.5, ...
        'Position', [700, 195, 200, 25], ...
        'Tag', 'tree', ...
        'Callback', {@tree_pgrow_Callback, htext} ...
    ); %生长概率
    htext = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'text', ...
        'FontSize', 12, ...
        'String', '着火概率：0', ...
        'Tag', 'tree', ...
        'Position', [700, 155, 200, 25] ...
    ); %着火概率文字
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'slider', ...
        'FontSize', 12, ...
        'Value', 0.5, ...
        'Position', [700, 130, 200, 25], ...
        'Tag', 'tree', ...
        'Callback', {@tree_pfire_Callback, htext} ...
    ); %着火概率
    %heart部分
    htext = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'text', ...
        'FontSize', 12, ...
        'String', '初始分布：0', ...
        'Tag', 'heart', ...
        'Position', [700, 220, 200, 25] ...
    ); %初始分布文字
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'slider', ...
        'FontSize', 12, ...
        'Value', 0.5, ...
        'Position', [700, 195, 200, 25], ...
        'Tag', 'heart', ...
        'Callback', {@heart_pinit_Callback, htext} ...
    ); %初始分布
    htext = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'text', ...
        'FontSize', 12, ...
        'String', '过激发层级：0', ...
        'Tag', 'heart', ...
        'Position', [700, 155, 200, 25] ...
    ); %过激发层级文字
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'slider', ...
        'FontSize', 12, ...
        'Value', 0.5, ...
        'SliderStep', [0.4 0.4], ...
        'Position', [700, 130, 200, 25], ...
        'Tag', 'heart', ...
        'Callback', {@heart_tlevel_Callback, htext} ...
    ); %过激发层级
    %seed部分
    htext = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'text', ...
        'FontSize', 12, ...
        'String', '初始分布：0', ...
        'Tag', 'seed', ...
        'Position', [700, 220, 200, 25] ...
    ); %初始分布文字
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'slider', ...
        'FontSize', 12, ...
        'Value', 0.5, ...
        'Position', [700, 195, 200, 25], ...
        'Tag', 'seed', ...
        'Callback', {@seed_pinit_Callback, htext} ...
    ); %初始分布
    %brain部分
    htext = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'text', ...
        'FontSize', 12, ...
        'String', '初始分布：0', ...
        'Tag', 'brain', ...
        'Position', [700, 220, 200, 25] ...
    ); %初始分布文字
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'slider', ...
        'FontSize', 12, ...
        'Value', 0.5, ...
        'Position', [700, 195, 200, 25], ...
        'Tag', 'brain', ...
        'Callback', {@brain_pinit_Callback, htext} ...
    ); %初始分布
    %flow部分
    htext = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'text', ...
        'FontSize', 12, ...
        'String', '初始分布：0', ...
        'Tag', 'flow', ...
        'Position', [700, 220, 200, 25] ...
    ); %初始分布文字
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'slider', ...
        'FontSize', 12, ...
        'Value', 0.5, ...
        'Position', [700, 195, 200, 25], ...
        'Tag', 'flow', ...
        'Callback', {@flow_pinit_Callback, htext} ...
    ); %初始分布
    htext = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'text', ...
        'FontSize', 12, ...
        'String', '初始颜色：0', ...
        'Tag', 'flow', ...
        'Position', [700, 155, 200, 25] ...
    ); %初始颜色文字
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'slider', ...
        'FontSize', 12, ...
        'Value', 0.5, ...
        'SliderStep', [0.2 0.4], ...
        'Position', [700, 130, 200, 25], ...
        'Tag', 'flow', ...
        'Callback', {@flow_ccolor_Callback, htext} ...
    ); %初始颜色
    htext = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'text', ...
        'FontSize', 12, ...
        'String', '渗流概率：0', ...
        'Tag', 'flow', ...
        'Position', [700, 90, 200, 25] ...
    ); %渗流概率文字
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'slider', ...
        'FontSize', 12, ...
        'Value', 0.5, ...
        'Position', [700, 65, 200, 25], ...
        'Tag', 'flow', ...
        'Callback', {@flow_pflow_Callback, htext} ...
    ); %渗流概率
    %gas部分
    htext = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'text', ...
        'FontSize', 12, ...
        'String', '初始分布：0', ...
        'Tag', 'gas', ...
        'Position', [700, 220, 200, 25] ...
    ); %初始分布文字
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'slider', ...
        'FontSize', 12, ...
        'Value', 0.5, ...
        'Position', [700, 195, 200, 25], ...
        'Tag', 'gas', ...
        'Callback', {@gas_pinit_Callback, htext} ...
    ); %初始分布
    %snow部分
    htext = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'text', ...
        'FontSize', 12, ...
        'String', '初始分布：0', ...
        'Tag', 'snow', ...
        'Position', [700, 220, 200, 25] ...
    ); %初始分布文字
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'slider', ...
        'FontSize', 12, ...
        'Value', 0.5, ...
        'Position', [700, 195, 200, 25], ...
        'Tag', 'snow', ...
        'Callback', {@snow_pinit_Callback, htext} ...
    ); %初始分布
    %sand部分
    htext = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'text', ...
        'FontSize', 12, ...
        'String', '震荡概率：0', ...
        'Tag', 'sand', ...
        'Position', [700, 220, 200, 25] ...
    ); %震荡概率文字
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'slider', ...
        'FontSize', 12, ...
        'Value', 0.5, ...
        'Position', [700, 195, 200, 25], ...
        'Tag', 'sand', ...
        'Callback', {@sand_pshake_Callback, htext} ...
    ); %震荡概率
    htext = uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'text', ...
        'FontSize', 12, ...
        'String', '粘滞概率：0', ...
        'Tag', 'sand', ...
        'Position', [700, 155, 200, 25] ...
    ); %粘滞概率文字
    uicontrol( ...
        'Units', 'pixels', ...
        'Style', 'slider', ...
        'FontSize', 12, ...
        'Value', 0.5, ...
        'Position', [700, 130, 200, 25], ...
        'Tag', 'sand', ...
        'Callback', {@sand_pstick_Callback, htext} ...
    ); %粘滞概率
    %所有文字和按钮对齐
    align(findobj(hfig, 'Type', 'UIControl'), 'Center', 'None');
    % 产生数据集
    cell_reset_all();
    hpopup.String = cell_list(:,1);
    v = hpopup.Value;
    cell_init = cell_list{v,2};
    cell_run = cell_list{v,3};
    cell_p = cell_data.(cell_list{v,4});
    cell_c = cell_p.color;
    cell_d = cell_data.common;
    width = cell_d.w;
    cells = zeros(width);
    himg = image(cat(3, cells, cells, cells));
    cell_e = {}; %额外数据
    cells_w = cell_out(); %边界数据
    % 绘制默认数据
    cell_show(cell_list{v,4});
    cell_time(0);
    cell_draw();
    % 将窗口居中
    movegui(hfig, 'center');
    % 绘制完毕，使窗口可见
    hfig.Visible = 'on';
    while isvalid(hfig)
        if hpause.Value == 0
            cell_time(1);
        end
        cell_draw();
        pause(0.01);
    end % 主循环
    % 所有响应函数
    function popup_Callback(src, event)
        % 下拉框响应 切换数据集
        val = src.Value;
        cell_init = cell_list{val,2};
        cell_run = cell_list{val,3};
        cell_p = cell_data.(cell_list{val,4});
        cell_c = cell_p.color;
        % 初始化图形
        cell_show(cell_list{val,4});
        cell_time(0);
    end
    function restart_Callback(src, event)
        % restart按钮响应
        % 初始化图形
        cell_time(0);
    end
    function pause_Callback(src, event)
        % pause按钮响应
        if src.Value == 0
            src.String = '暂停';
        else
            src.String = '运行';
        end
    end
    function next_Callback(src, event)
        % next按钮响应
        cell_time(1);
    end
    function width_Callback(src, event, htext, varargin)
        % width按钮响应(2个按钮)
        % 这里的逻辑很复杂，slider会调用checkbox
        switch length(varargin)
            case 1
                src.Value = round(src.Value);
                htext.Value = src.Value;
                width_Callback(varargin{1}, event, htext)
            case 0
                val = htext.Value;
                if src.Value == 1
                    val = round(val / 50) * 50;
                end
                htext.String = sprintf('元胞宽度：%3d', val);
                cell_data.common.w = val;
                cell_d = cell_data.common;
        end
    end
    function reset_Callback(src, event)
        % reset按钮响应 重置可变参数
        for uiobj = findobj(hfig, '-regexp', 'Tag', '[^'']')'
            if strcmp(uiobj.Style, 'slider') && strcmp(uiobj.Visible, 'on')
                uiobj.Value = 0.5;
                uiobj.Callback{1}(uiobj,'reset',uiobj.Callback{2:end})
            end
        end
    end
    function wall_Callback(src, event)
        % wall按钮响应
        if src.Value == 0
            src.String = '添加边界';
        else
            src.String = '去除边界';
        end
        cell_data.common.wall = src.Value;
        cell_d = cell_data.common;
    end
    function life_pinit_Callback(src, event, htext)
        val = round(src.Value * 100);
        htext.String = sprintf('初始分布：%3d%%', val);
        cell_data.life.pinit = val / 100;
        cell_p = cell_data.life;
    end
    function surf_pinit_Callback(src, event, htext)
        val = round(src.Value * 200) / 10 + 40;
        htext.String = sprintf('初始分布：%3.1f%%', val);
        cell_data.surf.pinit = val / 100;
        cell_p = cell_data.surf;
    end
    function tree_pgrow_Callback(src, event, htext)
        val = 100 ^ src.Value / 10;
        htext.String = sprintf('生长概率：%3.2f%%', val);
        cell_data.tree.pgrow = val / 100;
        cell_p = cell_data.tree;
    end
    function tree_pfire_Callback(src, event, htext)
        val = 10000 ^ src.Value / 200000;
        htext.String = sprintf('着火概率：%3.1E%%', val);
        cell_data.tree.pfire = val / 100;
        cell_p = cell_data.tree;
    end
    function heart_pinit_Callback(src, event, htext)
        val = 16 ^ src.Value;
        htext.String = sprintf('初始分布：%3.1f%%', val);
        cell_data.heart.pinit = val / 100;
        cell_p = cell_data.heart;
    end
    function heart_tlevel_Callback(src, event, htext)
        src.Value = round(src.Value * 2) / 2;
        val = src.Value * 2 + 5;
        htext.String = sprintf('过激发层级：%3d', val);
        cell_data.heart.tlevel = val;
        cell_p = cell_data.heart;
    end
    function seed_pinit_Callback(src, event, htext)
        val = 9 ^ src.Value / 10;
        htext.String = sprintf('初始分布：%3.2f%%', val);
        cell_data.seed.pinit = val / 100;
        cell_p = cell_data.seed;
    end
    function brain_pinit_Callback(src, event, htext)
        val = 9 ^ src.Value / 10;
        htext.String = sprintf('初始分布：%3.2f%%', val);
        cell_data.brain.pinit = val / 100;
        cell_p = cell_data.brain;
    end
    function flow_pinit_Callback(src, event, htext)
        val = 625 ^ (src.Value ^ 2) / 1000;
        htext.String = sprintf('初始分布：%3.4f%%', val);
        cell_data.flow.pinit = val / 100;
        cell_p = cell_data.flow;
    end
    function flow_ccolor_Callback(src, event, htext)
        src.Value = floor(src.Value * 5) / 5;
        val = src.Value * 5 + 1;
        htext.String = sprintf('颜色数量：%3d', val);
        cell_data.flow.ccolor = val;
        cell_p = cell_data.flow;
    end
    function flow_pflow_Callback(src, event, htext)
        val = 100 ^ src.Value / 2;
        htext.String = sprintf('渗流概率：%3.2f%%', val);
        cell_data.flow.pflow = val / 100;
        cell_p = cell_data.flow;
    end
    function gas_pinit_Callback(src, event, htext)
        val = src.Value * 90 + 5;
        htext.String = sprintf('初始分布：%3.1f%%', val);
        cell_data.gas.pinit = val / 100;
        cell_p = cell_data.gas;
    end
    function snow_pinit_Callback(src, event, htext)
        val = 25 ^ src.Value + 5;
        htext.String = sprintf('初始分布：%3.1f%%', val);
        cell_data.snow.pinit = val / 100;
        cell_p = cell_data.snow;
    end
    function sand_pshake_Callback(src, event, htext)
        val = src.Value * 8 + 1;
        htext.String = sprintf('震荡概率：%3.2f%%', val);
        cell_data.sand.pshake = val / 100;
        cell_p = cell_data.sand;
    end
    function sand_pstick_Callback(src, event, htext)
        val = src.Value * 90 + 5;
        htext.String = sprintf('粘滞概率：%3.0f%%', val);
        cell_data.sand.pstick = val / 100;
        cell_p = cell_data.sand;
    end
    % 处理函数
    function cell_reset_all()
        % 重置所有可变参数
        for uiobj = findobj(hfig, '-regexp', 'Tag', '[^'']')'
            if strcmp(uiobj.Style, 'slider')
                uiobj.Value = 0.5;
                uiobj.Callback{1}(uiobj,'reset',uiobj.Callback{2:end})
            end
        end
    end
    function cell_time(state)
        % 运行和初始化函数，统计运行时间
        % state = 0时为初始化，state = 1是为下一步
        if state
            htime.Value = htime.Value + 1;
            cell_run();
        else
            htime.Value = 0;
            cell_size();
            cell_init();
        end
        htime.String = sprintf('运行时长：%5d', htime.Value);
    end
    function cell_draw()
        % 根据cells绘制图形
        % 0/8为黑色 1为红色 2为绿色 4为蓝色 3为黄色 5为紫色 6为青色 7为白色
        RGB = cat(3, bitget(cells, 1), bitget(cells, 2), bitget(cells, 3));
        set(himg, 'cdata', RGB);
        drawnow;
    end
    function cell_size()
        %确定图像区域大小
        w = cell_data.common.w;
        cell_data.common.step = 2:2:w-1;
        cell_d = cell_data.common;
        width = cell_d.w;
        cells = zeros(width);
        himg = image(cat(3, cells, cells, cells));
        cells_w = cell_out();
    end
    function cell_show(tag)
        %展示相应元件
        for uiobj = findobj(hfig, '-regexp', 'Tag', '[^'']')'
            if regexp(uiobj.Tag, ['\<' tag '\>'])
                uiobj.Visible = 'on';
            else
                uiobj.Visible = 'off';
            end
        end
    end
    function cell_life_init()
        % 普通元胞自动机初始化
        d = cell_d;
        p = cell_p;
        c = p.color;
        cell_e = {};
        cells = cells * 0 + c.dead;
        cells(rand(width) < p.pinit) = c.live;
        cells(cells_w & d.wall) = c.wall;
    end
    function cell_life_run()
        % 普通元胞自动机运行
        d = cell_d;
        p = cell_p;
        c = p.color;
        cells_l = cells == c.live;
        cells_s = cell_sum(cells_l, 8);
        cells_l = cells_l & (cells_s==2) | (cells_s==3);
        cells = cells * 0 + c.dead;
        cells(cells_l) = c.live;
        cells(cells_w & d.wall) = c.wall;
    end
    function cell_surf_init()
        % 表面张力元胞自动机初始化
        d = cell_d;
        p = cell_p;
        c = p.color;
        cell_e = {};
        cells = cells * 0 + c.dead;
        cells(rand(width) < p.pinit) = c.live;
        cells(cells_w & d.wall) = c.wall;
    end
    function cell_surf_run()
        % 表面张力元胞自动机运行
        d = cell_d;
        p = cell_p;
        c = p.color;
        cells_l = cells == c.live;
        cells_s = cell_sum(cells_l, 9);
        cells_l = cells_s == 4 | cells_s > 5;
        cells = cells * 0 + c.dead;
        cells(cells_l) = c.live;
        cells(cells_w & d.wall) = c.wall;
    end
    function cell_tree_init()
        % 森林火灾元胞自动机初始化
        d = cell_d;
        p = cell_p;
        c = p.color;
        cell_e = {};
        cells = cells * 0 + c.empty;
        cells(cells_w & d.wall) = c.wall;
    end
    function cell_tree_run()
        % 森林火灾元胞自动机运行
        d = cell_d;
        p = cell_p;
        c = p.color;
        cells_b = cells == c.fire;
        cells_b = cell_sum(cells_b, 4) ~= 0 | rand(width) < p.pfire;
        cells_t = cells == c.tree;
        cells_b = cells_t & cells_b; % 燃烧的格子
        cells_t = cells == c.empty & rand(width) < p.pgrow | cells_t; % 树的格子
        cells = cells * 0 + c.empty;
        cells(cells_t) = c.tree;
        cells(cells_b) = c.fire;
        cells(cells_w & d.wall) = c.wall;
    end
    function cell_heart_init()
        % 激发介质元胞自动机初始化
        d = cell_d;
        p = cell_p;
        c = p.color;
        cells = cells * 0 + c.dead;
        cells(rand(width) < p.pinit) = c.live;
        cells(cells_w & d.wall) = c.wall;
        cell_e = {cells == c.live + 0};
    end
    function cell_heart_run()
        % 激发介质元胞自动机运行
        d = cell_d;
        p = cell_p;
        c = p.color;
        cells_l = cells == c.live;
        cells_t = cells_l & cell_e{1} < p.tlevel;
        cells_g = ~cells_l & cell_sum(cells_t, 8) > 2;
        cell_e{1} = cell_e{1} + cells_l;
        cell_e{1}(cells_g) = 1;
        cell_e{1}(cell_e{1} >= p.tmax | cells_w * d.wall) = 0;
        cells = cells * 0 + c.dead;
        cells(cell_e{1} > 0) = c.live;
        cells(cells_w & d.wall) = c.wall;
    end
    function cell_seed_init()
        % 种子元胞自动机初始化
        d = cell_d;
        p = cell_p;
        c = p.color;
        cell_e = {};
        cells = cells * 0 + c.dead;
        cells(rand(width) < p.pinit) = c.live;
        cells(cells_w & d.wall) = c.wall;
    end
    function cell_seed_run()
        % 种子元胞自动机运行
        d = cell_d;
        p = cell_p;
        c = p.color;
        cells_l = cells == c.live;
        cells_l = cell_sum(cells_l, 8) == 2;
        cells = cells * 0 + c.dead;
        cells(cells_l) = c.live;
        cells(cells_w & d.wall) = c.wall;
    end
    function cell_brain_init()
        % 波浪元胞自动机初始化
        d = cell_d;
        p = cell_p;
        c = p.color;
        cell_e = {};
        cells = cells * 0 + c.dead;
        cells(rand(width) < p.pinit) = c.live;
        cells(cells_w & d.wall) = c.wall;
    end
    function cell_brain_run()
        % 波浪元胞自动机运行
        d = cell_d;
        p = cell_p;
        c = p.color;
        cells_l = cells == c.live;
        cells_n = cell_sum(cells_l, 8) == 2 & cells == c.dead;
        cells = cells * 0 + c.dead;
        cells(cells_l) = c.dying;
        cells(cells_n) = c.live;
        cells(cells_w & d.wall) = c.wall;
    end
    function cell_flow_init()
        % 渗流元胞自动机初始化
        d = cell_d;
        p = cell_p;
        c = p.color;
        cell_e = {};
        cells = cells * 0 + c.dead;
        for i = c.live(1:p.ccolor)
            cells(rand(width) < p.pinit) = i;
        end
        cells(cells_w & d.wall) = c.wall;
    end
    function cell_flow_run()
        % 渗流元胞自动机运行
        d = cell_d;
        p = cell_p;
        c = p.color;
        cells_l = cells ~= c.dead & cells ~= c.wall;
        cells_n = cell_sum(cells ~= c.dead, 8) == 1 & rand(width) < p.pflow;
        cells_c = mod(cell_sum(cells, 8), 8);
        cells(cells_n) = cells_c(cells_n);
        cells(cells == c.wall) = c.dead;
        cells(cells_w & d.wall) = c.wall;
    end
    function cell_gas_init()
        % 气体动力元胞自动机初始化
        d = cell_d;
        p = cell_p;
        c = p.color;
        cell_e = {};
        w_h = width + 1;
        w_f = floor(w_h / 2);
        w_c = ceil(w_h / 2);
        cells_b = cells_w;
        cells_b([1:w_f-2 w_c+2:width], w_f:w_c) = 1;
        cells_l = rand(width) < p.pinit;
        cells_l(:,w_f:width) = 0;
        cells = cells * 0 + c.empty;
        cells(~~cells_l) = c.gas;
        cells(~~cells_b) = c.wall;
    end
    function cell_gas_run()
        % 气体动力元胞自动机运行
        d = cell_d;
        p = cell_p;
        c = p.color;
        t = d.step - bitand(htime.Value, 1);
        tp = t + 1;
        cells_b = cells == c.wall;
        cells_s = ~cell_sum(cells_b, 3);
        cells_s([t tp],[t tp]) = cells_s([t t],[t t]);
        cells_g = cells == c.gas;
        cells_g([tp t],[tp t]) = cells_g([t tp],[t tp]) .* cells_s([t t],[t t]);
        [tl, tr, br, bl] = cell_split(cells_g, t);
        cel_c = ~tl&tr&bl&~br | tl&~tr&~bl&br;
        cel_c = repmat(cel_c, 2, 2);
        cells_g([t tp],[t tp]) = bitxor(cells_g([t tp],[t tp]), cel_c);
        cells(cells_s) = c.empty;
        cells(cells_g) = c.gas;
    end
    function cell_snow_init()
        % 雪花元胞自动机初始化
        d = cell_d;
        p = cell_p;
        c = p.color;
        cell_e = {};
        w_h = (width + 1) / 2;
        w_f = floor(w_h);
        w_c = ceil(w_h);
        cells = cells * 0 + c.empty;
        cells(rand(width) < p.pinit) = c.steam;
        cells(w_f:w_c,w_f:w_c) = c.snow;
        cells(~~cells_w) = c.empty;
    end
    function cell_snow_run()
        % 雪花元胞自动机运行
        d = cell_d;
        p = cell_p;
        c = p.color;
        t = d.step - bitand(htime.Value, 1);
        cells_i = cells == c.snow;
        cells_s = cell_sum(cells_i, 8);
        cells_f = cells == c.steam;
        [tl, tr, br, bl] = cell_split(cells_f, t);
        cells_p = repmat(rand(length(t)) < 0.5, 1, 4);
        cells_m = cells_p.*[tr, br, bl, tl] + ~cells_p.*[bl, tl, tr, br];
        cells_f = cell_join(cells_f, cells_m, t);
        cells = cells * 0 + c.empty;
        cells(cells_f) = c.steam;
        cells(cells_i | cells_s & cells_f) = c.snow;
    end
    function cell_sand_init()
        % 沙漏元胞自动机初始化
        d = cell_d;
        p = cell_p;
        c = p.color;
        cell_e = {};
        w_h = width + 1;
        w_f = floor(w_h / 2);
        w_t = round(width / 5);
        % 制造沙漏形状
        x_b = [w_f-2, w_t] + 0.5;
        y_b = [w_f-1, 2] + 0.5;
        x_b = [x_b, w_h-x_b(end:-1:1)];
        y_b = [y_b, y_b(end:-1:1)];
        cells_b = ~roipoly(cells, [x_b, w_h-x_b], [y_b, w_h-y_b]);
        cells = ones(width) * c.empty;
        cells(5:w_f-1,:) = c.sand;
        cells(cells_b) = c.wall;
    end
    function cell_sand_run()
        % 沙漏元胞自动机运行
        d = cell_d;
        p = cell_p;
        c = p.color;
        t = d.step - bitand(htime.Value, 1);
        tp = t + 1;
        cells_s = cells == c.sand;
        cells_b = cells == c.wall;
        [tl, tr, br, bl] = cell_split(cells_s | cells_b, t);
        [tlb, trb, brb, blb] = cell_split(cells_b, t);
        %沙子下落
        cel_s = tl&tr&~br&~bl& rand(length(t)) < p.pstick;
        l_s = tl&~bl&~tlb&~cel_s;
        r_s = tr&~br&~trb&~cel_s;
        tl = bitxor(tl, l_s);
        tr = bitxor(tr, r_s);
        br = bitxor(br, r_s);
        bl = bitxor(bl, l_s);
        %沙子倾倒
        l_s = tl&bl&~br&~tlb;
        r_s = tr&br&~bl&~trb;
        tl = bitxor(tl, l_s);
        tr = bitxor(tr, r_s);
        br = bitxor(br, l_s);
        bl = bitxor(bl, r_s);
        %沙子震动
        cel_s = rand(length(t)) < p.pshake;
        t_s = (tl&~tr|~tl&tr)&~tlb&~trb&cel_s;
        b_s = (bl&~br|~bl&br)&~blb&~brb&cel_s;
        tl = bitxor(tl, t_s);
        tr = bitxor(tr, t_s);
        br = bitxor(br, b_s);
        bl = bitxor(bl, b_s);
        cells_s = cell_join(cells_b, [tl tr br bl], t);
        cells(~cells_b) = c.empty;
        cells(cells_s) = c.sand;
        cells(cells_b) = c.wall;
        
    end

    % 辅助函数
    function R = cell_out()
        % 获取边界
        d = cell_d;
        w = d.wall_w - 1;
        R = zeros(width);
        R(:, [1:1+w width-w:width]) = 1;
        R([1:1+w width-w:width], :) = 1;
    end
    function R = cell_sum(cell, mode)
        % 将最常用的几种元胞加法合并(3 4 5 8 9)
        % 4是冯诺依曼元胞加法 8是摩尔元胞加法 +1是包括自身 3是气体元胞加法
        d = cell_d;
        R = cell * bitget(mode, 1);
        if bitget(mode, 2)
            R = R + circshift(cell, [-1 0]) + circshift(cell, [0 -1]);
            R = R + circshift(cell, [-1 -1]);
        end
        if any(bitget(mode, [3 4]))
            R = R + circshift(cell, [1 0]) + circshift(cell, [-1 0]);
            R = R + circshift(cell, [0 1]) + circshift(cell, [0 -1]);
        end
        if bitget(mode, 4)
            R = R + circshift(cell, [1 1]) + circshift(cell, [-1 -1]);
            R = R + circshift(cell, [-1 1]) + circshift(cell, [1 -1]);
        end
    end
    function [tl, tr, br, bl] = cell_split(cells_t, t)
        tp = t + 1;
        tl = cells_t(t, t);
        tr = cells_t(t, tp);
        bl = cells_t(tp, t);
        br = cells_t(tp, tp);
    end
    function R = cell_join(cells_i, cells_b, t)
        R = cells_i;
        l = length(t);
        tp = t + 1;
        R(t, t) = cells_b(:,1:l);
        R(t, tp) = cells_b(:,l+1:l*2);
        R(tp, tp) = cells_b(:,l*2+1:l*3);
        R(tp, t) = cells_b(:,l*3+1:l*4);
    end
end
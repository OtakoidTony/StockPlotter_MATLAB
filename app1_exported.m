classdef app1_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure            matlab.ui.Figure
        GridLayout          matlab.ui.container.GridLayout
        LeftPanel           matlab.ui.container.Panel
        CodeEditField       matlab.ui.control.EditField
        StartButton         matlab.ui.control.Button
        CodeEditFieldLabel  matlab.ui.control.Label
        RightPanel          matlab.ui.container.Panel
        UIAxes              matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            code = "251270";
            candle(app.UIAxes, [get_finance_datas(code, 1); get_finance_datas(code, 2); get_finance_datas(code, 3); get_finance_datas(code, 4)])
            title(app.UIAxes, 'Candlestick chart for 251270')
            xlabel(app.UIAxes, "")
            ylabel(app.UIAxes, "")
        end

        % Button pushed function: StartButton
        function StartButtonPushed(app, event)
            code = app.CodeEditField.Value;
            disp(code)
            candle(app.UIAxes, [get_finance_datas(code, 1); get_finance_datas(code, 2); get_finance_datas(code, 3); get_finance_datas(code, 4)])
            title(app.UIAxes, "Candlestick chart for "+code)
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {494, 494};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {220, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 767 494];
            app.UIFigure.Name = 'UI Figure';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {220, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create CodeEditField
            app.CodeEditField = uieditfield(app.LeftPanel, 'text');
            app.CodeEditField.Position = [84 440 100 22];

            % Create StartButton
            app.StartButton = uibutton(app.LeftPanel, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.Position = [60 400 100 22];
            app.StartButton.Text = 'Start';

            % Create CodeEditFieldLabel
            app.CodeEditFieldLabel = uilabel(app.LeftPanel);
            app.CodeEditFieldLabel.HorizontalAlignment = 'right';
            app.CodeEditFieldLabel.Position = [35 440 34 22];
            app.CodeEditFieldLabel.Text = 'Code';

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.RightPanel);
            title(app.UIAxes, 'Plot')
            xlabel(app.UIAxes, '')
            ylabel(app.UIAxes, '')
            app.UIAxes.TitleFontWeight = 'bold';
            app.UIAxes.Position = [4 6 537 485];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
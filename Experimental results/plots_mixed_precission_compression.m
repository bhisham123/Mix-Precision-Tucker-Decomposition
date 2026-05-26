clc
clear all
close all


dataset = "heat";   %dataset options: "heat" "HCCI" "miranda" "mhd"  
alpha = 1;

dataset = char(dataset);
if strcmp(dataset, "heat")|| strcmp(dataset, "HCCI")
    mix_prec_vec = ["7prec", "dsb", "ds" ];
else
    mix_prec_vec = ["3prec", "sb"];
end

markers = ["*", "+",  "d", "v", "o","p"];
colors = {'#FF0000', '#FF8C00', '#4169E1'};


f = figure('Position', [0, 0, 1500, 500]);
subplot(1,2,1,'Parent',f);
hold on;
for i = 1:length(mix_prec_vec)
    mix_prec = mix_prec_vec(i);
    file_name = dataset + "_"+num2str(alpha)+"_" + mix_prec + "_hosvd.mat";
    load(file_name);
    if strcmp(mix_prec,"7prec")|| strcmp(mix_prec,"3prec")
       plot(eps_vec, (err.full)./eps_vec',  'ko--','markersize',8,'linewidth',2.5,'DisplayName', 'Full (HOSVD(\epsilon))');
    end
    plot(eps_vec, (err.coreMP.relX)./eps_vec','color', colors{i}, 'marker', markers(i),'markersize',8,'linewidth',2.5,'DisplayName', mix_prec+" (core only)");
    plot(eps_vec, (err.coreFactorMP.relX)./eps_vec','color', colors{i},'marker', markers(i),'markersize',8, 'linewidth',2.5,'LineStyle', ':','DisplayName', mix_prec+ " (both)");
end

h=yline(1,'k-','linewidth',2.5);
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
set(gca,'FontSize',14)
legend('Location','best','FontSize',12.5)
set(gca, 'XScale', 'log');   % log scale for x-axis
xlabel('Tolerance (\epsilon)', 'FontSize', 16)
ylabel('Error-Tolerance Ratio', 'FontSize', 16)

ylim([-0.1 1.1])


if strcmp(dataset,"miranda")||strcmp(dataset,"mhd")
    xlim([8e-8, 1.2e-2])
    xticks([1e-7,1e-6,1e-5,1e-4, 1e-3, 1e-2])
else
    xlim([6e-15, 2e-2])
    xticks([1e-14,1e-13,1e-12,1e-11, 1e-10, 1e-9, 1e-8, 1e-7,1e-6,1e-5,1e-4, 1e-3, 1e-2])
end
box on;
grid on;


subplot(1,2,2,'Parent',f);
hold on;
for i = 1:length(mix_prec_vec)
    mix_prec = mix_prec_vec(i);
    file_name = dataset + "_"+num2str(alpha)+"_" + mix_prec + "_hosvd.mat";
    load(file_name);
    plot(eps_vec, ratio.Tt.coreMP, 'color', colors{i}, 'marker', markers(i),'markersize',8,'linewidth',2.5,'DisplayName', mix_prec+" (core only)");
    plot(eps_vec, ratio.Tt.coreFactorMP, 'color', colors{i},'marker', markers(i),'markersize',8, 'linewidth',2.5,'LineStyle', ':','DisplayName', mix_prec+ " (both)");
end
set(gca,'FontSize',14)
set(gca, 'XScale', 'log');   % log scale for x-axis
xlabel('Tolerance (\epsilon)', 'FontSize', 16)
ylabel('Compression Improvement Factor','FontSize', 16)

plot(eps_vec,ones(1,length(eps_vec)),'ko--','MarkerSize',8,'linewidth',2.5,'DisplayName','Full (HOSVD(\epsilon))')

lgd = legend('Location','best','FontSize',12.5);
yl = ylim;
if strcmp(dataset,"miranda")||strcmp(dataset,"mhd")
    ylim([0.9, 2.1])
else
    ylim([0.9, yl(2)*1.05])
end
if strcmp(dataset,"miranda")||strcmp(dataset,"mhd")
    xlim([8e-8, 1.2e-2])
    xticks([1e-7,1e-6,1e-5,1e-4, 1e-3, 1e-2])
else
    xlim([6e-15, 2e-2])
    xticks([1e-14,1e-13,1e-12,1e-11, 1e-10, 1e-9, 1e-8, 1e-7,1e-6,1e-5,1e-4, 1e-3, 1e-2])
end
box on; 
grid on;

% fname = dataset+"_new.png";
% exportgraphics(f, fname,'Resolution', 400);



if strcmp(dataset,"miranda") ||strcmp(dataset,"mhd")
    mix_prec_vec = ["3prec", "sb"];
    Precs  = ["s","rp24", "b"];
else
    mix_prec_vec = ["7prec","dsb", "ds"];
    Precs  = ["d","rp56","rp48","rp40","s","rp24", "b"];
end

file_name = dataset + "_"+num2str(alpha)+"_" + mix_prec_vec(1) + "_hosvd.mat";
load(file_name);

for i = 1:length(eps_vec)
    C_MPCore{i} = zeros(length(mix_prec_vec), length(Precs));
    C_MPCoreFact{i} = zeros(length(mix_prec_vec), length(Precs));
    for j = 1:length(mix_prec_vec)
        mix_prec = mix_prec_vec(j);
        file_name = dataset + "_"+num2str(alpha)+"_" + mix_prec + "_hosvd.mat";
        load(file_name);
        for k = 1:length(prec)
            idx = find(Precs == prec(k));
            C_MPCore{i}(j,idx) = count.coreMP{i}(k);
            C_MPCoreFact{i}(j,idx) = count.coreFactorMP{i}(k);
        end

    end
end

C = C_MPCoreFact;

gap = 1;

X = [];
Y = [];
XtickLabels = {};

xPos = 1;

for i = 1:numel(C)
    A = C{i}./sum(C{i},2);          % r x k
    r = size(A,1);

    % x positions for this group
    xBlock = xPos:(xPos+r-1);

    X = [X xBlock];
    Y = [Y; A];

    % create labels for each bar
    for j = 1:r
        XtickLabels{end+1} = mix_prec_vec(j); %sprintf('C%d-R%d', i, j);
    end

    % update position with gap
    xPos = xPos + r + gap;

    % optional blank labels for gap (if you want visual spacing)
    % for g = 1:gap
    %     XtickLabels{end+1} = '';
    % end
end

f = figure('Position', [0, 0, 1500, 750]);
hold on

b = bar(X, Y, 'stacked');

colors = [
    0.0000  0.4470  0.7410   % blue
    0.8500  0.3250  0.0980   % orange
    0.9290  0.6940  0.1250   % yellow
    0.4940  0.1840  0.5560   % purple
    0.4660  0.6740  0.1880   % green
    0.3010  0.7450  0.9330   % light blue
    0.6350  0.0780  0.1840   % dark red
    0.0000  0.6000  0.5000   % teal
    0.8000  0.2000  0.6000   % pink-magenta
    0.2000  0.2000  0.2000   % dark gray
];

for k = 1:length(Precs)
    if strcmp(dataset,'miranda')||strcmp(dataset,"mhd")
        b(k).FaceColor = colors(k+4,:);   
    else
        b(k).FaceColor = colors(k,:);
    end
end

if strcmp(dataset,"miranda")||strcmp(dataset,"mhd")
    legend("fp32","rp24","bfloat16", ...
       'FontSize', 15,'Location','eastoutside');
else
    legend("fp64","rp56","rp48","rp40","fp32","rp24","bfloat16", ...
       'FontSize', 15,'Location','eastoutside');
end
xticks(X);
xticklabels(XtickLabels);
set(gca, 'FontSize', 15)
xtickangle(90);

r = size(C{1},1);
ind = 1;
for i = 1:r:length(X)

    if strcmp(dataset,'miranda')||strcmp(dataset,"mhd")
        xCenter = X(i)+1.5-1;
    else
        xCenter = X(i)+2.2-1;
    end

    ax = gca;
    y = ax.YLim(1) - 1;  % slightly below lowest log value
    % y = -1;
    lab =  sprintf('%.0e', eps_vec(ind));
    % text(xCenter, y, lab, ...
    %     'HorizontalAlignment','center');
    xnorm = (xCenter - ax.XLim(1)) / (ax.XLim(2) - ax.XLim(1));
    text(xnorm, -0.09, lab, ...
    'Units','normalized', ...
    'HorizontalAlignment','center','FontSize', 17);
    ind = ind +1;
end

ylabel('Fraction of Elements in each Format','FontSize', 17)
box on;

% % sgtitle(dataset)
% fname = dataset+"_counts_new.png";
% exportgraphics(f, fname,'Resolution', 400);


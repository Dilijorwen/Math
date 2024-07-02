file_path = '100.txt';
start = 1;
end_ = 4;
num_sim = 10000;

adj = dlmread(file_path);

tic;
[fht, ct, sfh, sct, mfht, mct, eff_res, mcmt, scmt] = random_walk(adj, start, end_, num_sim);
elapsed_time = toc;

fprintf('Среднее время первого попадания в вершину %d из вершины %d: %f шага.\n', end_, start, mfht);
fprintf('Среднее время прохода из вершины %d в вершину %d и обратно: %f шага.\n', start, end_, mcmt);
fprintf('Среднее время обхода всего графа: %f шага.\n', mct);
fprintf('Эффективное сопротивление: %f.\n', eff_res);
fprintf('Время выполнения программы: %f секунд.\n', elapsed_time);

fprintf('Повторения времени первого попадания в вершину (в формате [время-количество]):\n');
for i = 1:size(sfh, 1)
    fprintf('[%d-%d]', sfh(i, 1), sfh(i, 2));
    if i ~= size(sfh, 1)
        fprintf(', ');
    else
        fprintf('.\n');
    end
end

fprintf('Повторения времени прохода из вершины %d в вершину %d и обратно (в формате [время-количество]):\n', start, end_);
for i = 1:size(scmt, 1)
    fprintf('[%d-%d]', scmt(i, 1), scmt(i, 2));
    if i ~= size(scmt, 1)
        fprintf(', ');
    else
        fprintf('.\n');
    end
end

fprintf('Повторения времени обхода всего графа (в формате [время-количество]):\n');
for i = 1:size(sct, 1)
    fprintf('[%d-%d]', sct(i, 1), sct(i, 2));
    if i ~= size(sct, 1)
        fprintf(', ');
    else
        fprintf('.\n');
    end
end

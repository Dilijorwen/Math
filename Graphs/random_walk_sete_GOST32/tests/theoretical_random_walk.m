file_path = 'moscow.txt';
adj_matrix = dlmread(file_path);

n = size(adj_matrix, 1);
m = sum(adj_matrix(:)) / 2;

degree_matrix = sum(adj_matrix, 2);

laplacian_matrix = diag(degree_matrix) - adj_matrix;

[eigenvectors, eigenvalues_matrix] = eig(laplacian_matrix);
eigenvalues = diag(eigenvalues_matrix);

eigenvalues_nonzero = eigenvalues(2:end);
eigenvectors_nonzero = eigenvectors(:, 2:end);

H = zeros(n, n);

max_iter = 200000;
tol = 1e-16;

tic;

neighbors = cell(n, 1);
for I = 1:n
    neighbors{I} = find(adj_matrix(I, :) == 1);
end

for iteration = 1:max_iter
    H_prev = H;
    for u = 1:n
        if degree_matrix(u) > 0
            H(u, :) = 1 + (1 / degree_matrix(u)) * sum(H(neighbors{u}, :), 1);
        end
        H(u, u) = 0;  % Условие H_ii = 0
    end
    if mod(iteration, 10000) == 0
        disp(['Итерация: ', num2str(iteration), ' H - ', num2str(max(max(abs(H - H_prev))))]);
    end
    if max(max(abs(H - H_prev))) < tol
        disp(['Сошлось после ', num2str(iteration), ' итераций']);
        break;
    end
end
elapsed_time = toc;


I = 1;
j = 421;

H_ij = H(I, j);

R_ij = sum((eigenvectors_nonzero(I, :) - eigenvectors_nonzero(j, :)).^2 ./ eigenvalues_nonzero');

C_ij = 2 * m * R_ij;

disp(['Среднее время прохода из вершины ', num2str(I), ' в вершину ', num2str(j), ': ', num2str(H_ij)]);
disp(['Среднее время прохода из вершины ', num2str(I), ' в вершину ', num2str(j), ' и обратно: ', num2str(C_ij)]);
disp(['Эффективное сопротивление: ', num2str(R_ij)]);
disp(['Время выполнения программы: ', num2str(elapsed_time), ' секунд']);

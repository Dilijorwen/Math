

disp("-------------------------------------------------------------------------------")
disp("    ГЕНЕРАТОР МАТРИЦЫ СМЕЖНОСТИ СВЯЗНОГО ГРАФА С ЗАДАННОЙ МАКСИМАЛЬНОЙ СТЕПЕНЬЮ  ")
disp("--------------------------------------------------------------------------------")



vertexNumber = input("Введите число вершин: ");
maxDegree = input("Введите максимальную степень вершины: ");
fileName = input("Введите имя файла для сохранения результатов (без расширения): ", 's');
fileName = [fileName, ".dat"];

disp("")


if isempty(vertexNumber)
        error("Количество вершин не задано!")
end

if isempty(maxDegree)
        error("Максимальная степень не задана!")
end

if strcmp(fileName, ".dat")
        error("Имя файла не задано!")
end

if not(fix(vertexNumber) == vertexNumber) || not(fix(maxDegree)==maxDegree)
        error("Количество и максимальная степень вершин должны быть целыми числами!")
end

if (maxDegree < 1) || (vertexNumber < 1)
        error("Количество и максимальная степень вершин должны быть положительными числами!")
end

if maxDegree > vertexNumber - 1
        error("Степень вершины не должна быть больше или равна количеству вершин!")
end

if ((maxDegree == 1) && not(vertexNumber == 2)) || ((vertexNumber > 2) && (maxDegree < 2))
        error("Невозможно сгенерировать связный граф при данных входных условиях")
end


vertexDegrees = zeros(1, vertexNumber);
adjacencyMatrix = zeros(vertexNumber);


function newVector = popElem(vector, index)
        vector(index) = vector(end);
        newVector = vector(1:end-1);
end



startTime = cputime();


disp("Построение остовного дерева...")

tic


visitedVertexes = [];
notVisitedVertexes = randperm(vertexNumber);


visitedVertexes = [visitedVertexes notVisitedVertexes(end)];
notVisitedVertexes = notVisitedVertexes(1:end-1);


while length(notVisitedVertexes) > 0
        visitedIndex = randi(length(visitedVertexes));
        visitedVertex = visitedVertexes(visitedIndex);
        
        notVisitedVertex = notVisitedVertexes(end);
        
        adjacencyMatrix(notVisitedVertex, visitedVertex) = 1;
        adjacencyMatrix(visitedVertex, notVisitedVertex) = 1;
        
        vertexDegrees(visitedVertex)++;
        vertexDegrees(notVisitedVertex)++;

        visitedVertexes = [visitedVertexes notVisitedVertex];
        notVisitedVertexes = notVisitedVertexes(1:end-1);

        if (vertexDegrees(visitedVertex) >= maxDegree)
                visitedVertexes = popElem(visitedVertexes, visitedIndex);
        end
end


spanningTreeTimeGen = toc;

disp(["Остовное дерево построено. Потраченное время: ", num2str(spanningTreeTimeGen), " с."])


disp("Добавление дополнительных ребер...")

tic

minEdgeNumber = vertexNumber - 1;
maxEdgeNumber =  floor(maxDegree*vertexNumber / 2);
additionalEdgesNumber = randi([minEdgeNumber, maxEdgeNumber]) - minEdgeNumber;


[i, j] = meshgrid(1:vertexNumber, 1:vertexNumber);
pairs = [i(:) j(:)];
pairs = pairs(i(:) < j(:), :);

existingEdges = find(adjacencyMatrix);
[existingRows, existingCols] = ind2sub(size(adjacencyMatrix), existingEdges);
existingPairs = [existingRows existingCols];
potentialPairs = setdiff(pairs, existingPairs, 'rows');


selectedPairs = potentialPairs(randperm(size(potentialPairs, 1), additionalEdgesNumber), :);

for k = 1:size(selectedPairs, 1)
        firstVertex = selectedPairs(k, 1);
        secondVertex = selectedPairs(k, 2);
        
        if (vertexDegrees(firstVertex) < maxDegree) && (vertexDegrees(secondVertex) < maxDegree)
                adjacencyMatrix(firstVertex, secondVertex) = 1;
                adjacencyMatrix(secondVertex, firstVertex) = 1;
                
                vertexDegrees(firstVertex)++;
                vertexDegrees(secondVertex)++;
        end
end


if max(vertexDegrees) < maxDegree
        maxDegreeVertex = randi(vertexNumber);
        
        
        connectedVertexes = find(adjacencyMatrix(maxDegreeVertex, :));
        allVertexes = linspace(1, vertexNumber, vertexNumber);
        allVertexesButMax = popElem(allVertexes, maxDegreeVertex);
        unconnectedVertexes = setdiff(allVertexesButMax, connectedVertexes);
         
        
        while vertexDegrees(maxDegreeVertex) < maxDegree
                curVertex = unconnectedVertexes(end);
                
                adjacencyMatrix(maxDegreeVertex, curVertex) = 1;
                adjacencyMatrix(curVertex, maxDegreeVertex) = 1;

                vertexDegrees(curVertex)++;
                vertexDegrees(maxDegreeVertex)++;

                unconnectedVertexes = unconnectedVertexes(1:end-1);
        end
        
end


edgeAdditionTime = toc;

disp(["Дополнительные ребра добавлены. Потраченное время: ", num2str(edgeAdditionTime), " с."])


totalGenTime = edgeAdditionTime + spanningTreeTimeGen;

disp(["Граф сгенерирован. Общее время генерации: ", num2str(totalGenTime), " с."])


disp("--------------------------------------------------------------------------------")
disp("                               ХАРАКТЕРИСТИКИ ГРАФА                             ")
disp("--------------------------------------------------------------------------------")

disp(["Количество ребер: ", num2str(sum(vertexDegrees)/2)])
disp(["Средняя степень вершины: ", num2str(sum(vertexDegrees)/vertexNumber)])
disp(["Максимальная степень вершины: ", num2str(max(vertexDegrees))])

disp("")


disp("Сохранение матрицы смежности...")

save(fileName, 'adjacencyMatrix');

disp(["Матрица смежности графа сохранена в файле ", fileName])


elapsedTime = cputime() - startTime;

disp(["Общее время работы программы: ", num2str(elapsedTime), " с."])
disp("")


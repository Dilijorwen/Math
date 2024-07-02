
function [fht, ct, sfh, sct, mfht, mct, eff_res, ...
mcmt, scmt] = random_walk(adj, start, end_, num_sim)

    n = size(adj, 1);
    m = sum(adj(:)) / 2;
    fht = zeros(num_sim, 1);
    ct = zeros(num_sim, 1);
    cmt = zeros(num_sim, 1);



    for sim = 1:num_sim
        curr = start;
        visited = false(n, 1);
        visited(start) = true;
        steps = 0;
        first_hit = false;
        visit_count = 1;


        while visit_count < n
            neighbors = find(adj(curr, :));
            next = neighbors(randi(length(neighbors)));
            steps = steps + 1;
            curr = next;


            if ~first_hit && curr == end_
                fht(sim) = steps;
                first_hit = true;
            end


            if ~visited(curr)
                visited(curr) = true;
                visit_count = visit_count + 1;
            end
        end


        ct(sim) = steps;


        cms = 0;
        curr = start;
        while curr ~= end_
            neighbors = find(adj(curr, :));
            next = neighbors(randi(length(neighbors)));
            cms = cms + 1;
            curr = next;
        end
        while curr ~= start
            neighbors = find(adj(curr, :));
            next = neighbors(randi(length(neighbors)));
            cms = cms + 1;
            curr = next;
        end
        cmt(sim) = cms;
    end



    sfh = sort_and_count(fht);
    sct = sort_and_count(ct);
    scmt = sort_and_count(cmt);
    mfht = mean(fht);
    mct = mean(ct);
    mcmt = mean(cmt);

    eff_res = mcmt / (2 * m);
end


function sc = sort_and_count(data)
    [sorted_data, ~, idx] = unique(data);
    counts = accumarray(idx, 1);
    sc = [sorted_data, counts];
end


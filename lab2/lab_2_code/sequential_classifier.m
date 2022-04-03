function [discriminant] = sequential_classifier(a,b,X,Y)
    orig_a = a;
    orig_b = b;
    j = 0;

    na = 0;
    nb = 0;
    naB = int16.empty;
    nbA = int16.empty;
    
    prototypes_A = double.empty(0,2);
    prototypes_B = double.empty(0,2);
 
    while true
        prototype_A = a(randi(size(a,1)),:);
        prototype_B = b(randi(size(b,1)),:);
                
        [classified_A, classified_B, conf_matrix] = MED(a, b, prototype_A,prototype_B);
        
        if conf_matrix(1,2) ~= 0 && conf_matrix(2,1) ~= 0
            continue
        end
        
        j=j+1;
        prototypes_A = vertcat(prototypes_A, prototype_A);
        prototypes_B = vertcat(prototypes_B, prototype_B);
        
         if conf_matrix(1,2) == 0
            b = setxor(b, classified_B, 'rows');
        end
            
        if conf_matrix(2,1) == 0
            a = setxor(a, classified_A, 'rows');
        end
 
        naB = vertcat(naB, conf_matrix(1,2));
        nbA = vertcat(nbA, conf_matrix(2,1));

        if size(a,1) == 0 || size(b,1) == 0
            % stop
            break
        end
    end
 
    discriminant = zeros(size(X));
    
    for i=1:size(discriminant,1)*size(discriminant,2)
        for k=1:j
            is_A = MED_is_A(prototypes_A(k,:), prototypes_B(k,:), [X(i), Y(i)]);
            if is_A && nbA(k)==0
                discriminant(i) = 1;
                break
            elseif ~is_A && naB(k)==0
                discriminant(i) = 0;
                break
            end
        end
    end
end

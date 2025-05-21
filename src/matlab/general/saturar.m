function y = saturar(x, min_val, max_val)
    % Función de saturación que limita x al rango [min_val, max_val]
    y = min(max(x, min_val), max_val);
end
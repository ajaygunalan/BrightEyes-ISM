function Err = RelErr(Truth, Estimation)
    Err = norm(Estimation-Truth,'fro')/norm(Truth,'fro')*100;
end
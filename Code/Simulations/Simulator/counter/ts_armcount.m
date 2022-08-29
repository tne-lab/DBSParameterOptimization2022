function [bookV] = ts_armcount(bookV)
    % Arm selected count and arm selected
    bookV.playArmSelected(:,bookV.trial) = bookV.armselected;
    %if (bookV.trial > 20)
    bookV.playArmSelected_count(bookV.armselected,1) = bookV.playArmSelected_count(bookV.armselected) +1;
    bookV.selection_probability(bookV.trial,:) = bookV.playArmSelected_count./sum(bookV.playArmSelected_count);
    %end
end
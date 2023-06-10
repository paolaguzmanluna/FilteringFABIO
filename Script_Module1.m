clear
close all

path =genpath( cd());
addpath(path)

fabio = readtable('resultsMatlab.csv');
fabio(:,1) = [];

%% 1)SORT THE IO TABLE BY CONTINENT ORIGIN AND GROUP ORIGIN 
country_origin = fabio.country_origin;
continent_origin = fabio.continent_origin;
value = fabio.value;

%% SPLIAPPLY function
[G,id1,id2] = findgroups(fabio.continent_origin,fabio.group_origin);
max(G); %60
min(G); %60
valorSumado = splitapply(@sum,value,G);

%% Convert valorSumado from double to cell
class(valorSumado); %double
valorSumado = num2cell(valorSumado) ;
class(valorSumado); %cell
%% integrate the vectors in a table
by_group_conti = [ valorSumado id1 id2];

%% 2)SORT IO TABLE BY SPECIFIC ITEMS AND CONTINENT ORIGIN
% create dif. vectors 
continent_origin = fabio.continent_origin;
country_origin = fabio.country_origin;
item_origin = fabio.item_origin;
country_producer = fabio.country_producer;
value = fabio.value;

%% SPLIAPPLY function
[G,id3,id4,id5,id6] = findgroups(fabio.continent_origin,fabio.country_origin,fabio.item_origin,fabio.country_producer);
max(G); %
min(G); %
valueAddup = splitapply(@sum,value,G);

%% Convert valorSumado from double to cell
class(valueAddup); %double
valueAddup_cell = num2cell(valueAddup); 
class(valueAddup_cell); %cell

%% integrate the vectors in a table
by_conti_count_item_producer = [ valueAddup_cell id3 id4 id5 id6];
by_conti_count_item_producer = cell2table(by_conti_count_item_producer);
by_conti_count_item_producer.Properties.VariableNames = {'value' 'continent_origin' 'country_origin' 'item_origin' 'country_user'};

%% FILTERING TO SPLIT THE IMTEMS THAT GO TO DAIRY FARMS AND TO THE PROCESSING PLANT

itemsFarms = by_conti_count_item_producer(contains(by_conti_count_item_producer.item_origin,{'Barley and products', 'Cassava and products','Cereals, Other','Fodder crops', 'Grazing', 'Maize and products', 'Millet and products','Oats', 'Oilcrops, Other', 'Pulses, Other and products', 'Rape and Mustardseed','Rye and products', 'Sorghum and products', 'Soyabeans', 'Sugar beet','Sugar cane', 'Sunflower seed', 'Wheat and products'}), : ); 
% it was reduced to only 18 items, initially there was 43
%% TOP 10 MILK PRODUCERS IN THE EU + UK
DEU = itemsFarms(itemsFarms.country_user == "DEU",:);
FRA = itemsFarms(itemsFarms.country_user == "FRA",:);
ESP = itemsFarms(itemsFarms.country_user == "ESP",:);
IRL = itemsFarms(itemsFarms.country_user == "IRL",:);
NLD = itemsFarms(itemsFarms.country_user == "NLD",:);
DNK = itemsFarms(itemsFarms.country_user == "DNK",:);
SWE = itemsFarms(itemsFarms.country_user == "SWE",:);
POL = itemsFarms(itemsFarms.country_user == "POL",:);
ITA = itemsFarms(itemsFarms.country_user == "ITA",:);
GBR = itemsFarms(itemsFarms.country_user == "GBR",:);

topMilkProd = [DEU; FRA; ESP; IRL; NLD; DNK; SWE; POL; ITA; GBR];
%% MAIN AGRICULTURAL BIOMASS SUPPLIERS TO THE TOP 10 MILK PRODUCERS
%% GERMANY
prod_deu = unique(DEU.item_origin); %18 items
n = length(prod_deu); %43 items
 
column_pro_deu = DEU.item_origin; %column for products
column_cont_deu = DEU.continent_origin; %column for continent
column_country_deu = DEU.country_origin; %column for countries
column_user_deu = DEU.country_user; 
% countries_deu = DEU.sort_item3 %column for countries 
column_val_deu = DEU.value; % column for value
prodAll_deu = cell(n,2);
 
for i = 1:n
    pos_prod_deu = strcmp(column_pro_deu, prod_deu{i}); %I find the position of n product
    max_prod_deu = max(column_val_deu(pos_prod_deu)); % I know the max number of the found product
    prodAll_deu{i,1}= max_prod_deu; % rows,columns...I save the position of the max number of the found product
    
    pos_country_deu = max_prod_deu == column_val_deu; %I find the position of n product
    selected_count_deu = column_country_deu(pos_country_deu); % I know the max number of the found product
    prodAll_deu{i,2}= selected_count_deu; % rows,columns...I save the position of the max number of the found product
    
    pos_conti_deu = max_prod_deu == column_val_deu; %I find the position of n product
    selected_conti_deu = column_cont_deu(pos_conti_deu); % I know the max number of the found product
    prodAll_deu{i,3}= selected_conti_deu; % rows,columns...I save the position of the max number of the found product
    
    pos_user_deu = max_prod_deu == column_val_deu; %I find the position of n product
    selected_user_deu = column_user_deu(pos_user_deu); % I know the max number of the found product
    prodAll_deu{i,4}= selected_user_deu; % rows,columns...I save the position of the max number of the found product      
end
mainSupDEU = [prodAll_deu prod_deu];
mainSupDEU = cell2table(mainSupDEU);
mainSupDEU.Properties.VariableNames = {'value' 'country_origin' 'continent_origin' 'item_origin' 'country_user'};
writetable(mainSupDEU,'largestSuppliers.xlsx', 'Sheet',1);

%% FRANCE
prod_fra = unique(FRA.item_origin); %43 items
n = length(prod_fra); %43 items

column_pro_fra = FRA.item_origin; %column for products
column_cont_fra = FRA.continent_origin; %column for continent
column_country_fra = FRA.country_origin; %column for countries
column_user_fra = FRA.country_user; 
% countries_fra = FRA.sort_item3 %column for countries 
column_val_fra = FRA.value; % column for value
prodAll_fra = cell(n,2);

for i = 1:n
    pos_prod_fra = strcmp(column_pro_fra, prod_fra{i}); %I find the position of n product
    max_prod_fra = max(column_val_fra(pos_prod_fra)); % I know the max number of the found product
    prodAll_fra{i,1}= max_prod_fra; % rows,columns...I save the position of the max number of the found product
    
    pos_country_fra = max_prod_fra == column_val_fra; %I find the position of n product
    selected_count_fra = column_country_fra(pos_country_fra); % I know the max number of the found product
    prodAll_fra{i,2}= selected_count_fra; % rows,columns...I save the position of the max number of the found product
    
    pos_conti_fra = max_prod_fra == column_val_fra; %I find the position of n product
    selected_conti_fra = column_cont_fra(pos_conti_fra); % I know the max number of the found product
    prodAll_fra{i,3}= selected_conti_fra; % rows,columns...I save the position of the max number of the found product
    
    pos_user_fra = max_prod_fra == column_val_fra; %I find the position of n product
    selected_user_fra = column_user_fra(pos_user_fra); % I know the max number of the found product
    prodAll_fra{i,4}= selected_user_fra; % rows,columns...I save the position of the max number of the found product      
end
mainSupFRA = [prodAll_fra prod_fra];
mainSupFRA = cell2table(mainSupFRA);
mainSupFRA.Properties.VariableNames = {'value' 'country_origin' 'continent_origin' 'item_origin' 'country_user'};
writetable(mainSupFRA,'largestSuppliers.xlsx', 'Sheet',2);

%% ESPAIN
prod_esp = unique(ESP.item_origin); %43 items
n = length(prod_esp); %43 items
 
column_pro_esp = ESP.item_origin; %column for products
column_cont_esp = ESP.continent_origin; %column for continent
column_country_esp = ESP.country_origin; %column for countries
column_user_esp = ESP.country_user; 
% countries_esp = ESP.sort_item3 %column for countries 
column_val_esp = ESP.value; % column for value
prodAll_esp = cell(n,2);
 
for i = 1:n
    pos_prod_esp = strcmp(column_pro_esp, prod_esp{i}); %I find the position of n product
    max_prod_esp = max(column_val_esp(pos_prod_esp)); % I know the max number of the found product
    prodAll_esp{i,1}= max_prod_esp; % rows,columns...I save the position of the max number of the found product
    
    pos_country_esp = max_prod_esp == column_val_esp; %I find the position of n product
    selected_count_esp = column_country_esp(pos_country_esp); % I know the max number of the found product
    prodAll_esp{i,2}= selected_count_esp; % rows,columns...I save the position of the max number of the found product
    
    pos_conti_esp = max_prod_esp == column_val_esp; %I find the position of n product
    selected_conti_esp = column_cont_esp(pos_conti_esp); % I know the max number of the found product
    prodAll_esp{i,3}= selected_conti_esp; % rows,columns...I save the position of the max number of the found product
    
    pos_user_esp = max_prod_esp == column_val_esp; %I find the position of n product
    selected_user_esp = column_user_esp(pos_user_esp); % I know the max number of the found product
    prodAll_esp{i,4}= selected_user_esp; % rows,columns...I save the position of the max number of the found product      
end
mainSupESP = [prodAll_esp prod_esp];
mainSupESP = cell2table(mainSupESP);
mainSupESP.Properties.VariableNames = {'value' 'country_origin' 'continent_origin' 'item_origin' 'country_user'};
writetable(mainSupESP,'largestSuppliers.xlsx', 'Sheet',3);

%% IRELAND
prod_irl = unique(IRL.item_origin); %43 items
n = length(prod_irl); %43 items
 
column_pro_irl = IRL.item_origin; %column for products
column_cont_irl = IRL.continent_origin; %column for continent
column_country_irl = IRL.country_origin; %column for countries
column_user_irl = IRL.country_user; 
% countries_irl = IRL.sort_item3 %column for countries 
column_val_irl = IRL.value; % column for value
prodAll_irl = cell(n,2);
 
for i = 1:n
    pos_prod_irl = strcmp(column_pro_irl, prod_irl{i}); %I find the position of n product
    max_prod_irl = max(column_val_irl(pos_prod_irl)); % I know the max number of the found product
    prodAll_irl{i,1}= max_prod_irl; % rows,columns...I save the position of the max number of the found product
    
    pos_country_irl = max_prod_irl == column_val_irl; %I find the position of n product
    selected_count_irl = column_country_irl(pos_country_irl); % I know the max number of the found product
    prodAll_irl{i,2}= selected_count_irl; % rows,columns...I save the position of the max number of the found product
    
    pos_conti_irl = max_prod_irl == column_val_irl; %I find the position of n product
    selected_conti_irl = column_cont_irl(pos_conti_irl); % I know the max number of the found product
    prodAll_irl{i,3}= selected_conti_irl; % rows,columns...I save the position of the max number of the found product
    
    pos_user_irl = max_prod_irl == column_val_irl; %I find the position of n product
    selected_user_irl = column_user_irl(pos_user_irl); % I know the max number of the found product
    prodAll_irl{i,4}= selected_user_irl; % rows,columns...I save the position of the max number of the found product      
end
mainSupIRL = [prodAll_irl prod_irl];
mainSupIRL = cell2table(mainSupIRL);
mainSupIRL.Properties.VariableNames = {'value' 'country_origin' 'continent_origin' 'item_origin' 'country_user'};
writetable(mainSupIRL,'largestSuppliers.xlsx', 'Sheet',4);

%% NETHERLANDS
prod_nld = unique(NLD.item_origin); %43 items
n = length(prod_nld); %43 items
 
column_pro_nld = NLD.item_origin; %column for products
column_cont_nld = NLD.continent_origin; %column for continent
column_country_nld = NLD.country_origin; %column for countries
column_user_nld = NLD.country_user; 
% countries_nld = NLD.sort_item3 %column for countries 
column_val_nld = NLD.value; % column for value
prodAll_nld = cell(n,2);
 
for i = 1:n
    pos_prod_nld = strcmp(column_pro_nld, prod_nld{i}); %I find the position of n product
    max_prod_nld = max(column_val_nld(pos_prod_nld)); % I know the max number of the found product
    prodAll_nld{i,1}= max_prod_nld; % rows,columns...I save the position of the max number of the found product
    
    pos_country_nld = max_prod_nld == column_val_nld; %I find the position of n product
    selected_count_nld = column_country_nld(pos_country_nld); % I know the max number of the found product
    prodAll_nld{i,2}= selected_count_nld; % rows,columns...I save the position of the max number of the found product
    
    pos_conti_nld = max_prod_nld == column_val_nld; %I find the position of n product
    selected_conti_nld = column_cont_nld(pos_conti_nld); % I know the max number of the found product
    prodAll_nld{i,3}= selected_conti_nld; % rows,columns...I save the position of the max number of the found product
    
    pos_user_nld = max_prod_nld == column_val_nld; %I find the position of n product
    selected_user_nld = column_user_nld(pos_user_nld); % I know the max number of the found product
    prodAll_nld{i,4}= selected_user_nld; % rows,columns...I save the position of the max number of the found product      
end
mainSupNLD = [prodAll_nld prod_nld];
mainSupNLD = cell2table(mainSupNLD);
mainSupNLD.Properties.VariableNames = {'value' 'country_origin' 'continent_origin' 'item_origin' 'country_user'};
writetable(mainSupNLD,'largestSuppliers.xlsx', 'Sheet',5);

%% DENMARK
prod_dnk = unique(DNK.item_origin); %43 items
n = length(prod_dnk); %43 items
 
column_pro_dnk = DNK.item_origin; %column for products
column_cont_dnk = DNK.continent_origin; %column for continent
column_country_dnk = DNK.country_origin; %column for countries
column_user_dnk = DNK.country_user; 
% countries_dnk = DNK.sort_item3 %column for countries 
column_val_dnk = DNK.value; % column for value
prodAll_dnk = cell(n,2);
 
for i = 1:n
    pos_prod_dnk = strcmp(column_pro_dnk, prod_dnk{i}); %I find the position of n product
    max_prod_dnk = max(column_val_dnk(pos_prod_dnk)); % I know the max number of the found product
    prodAll_dnk{i,1}= max_prod_dnk; % rows,columns...I save the position of the max number of the found product
    
    pos_country_dnk = max_prod_dnk == column_val_dnk; %I find the position of n product
    selected_count_dnk = column_country_dnk(pos_country_dnk); % I know the max number of the found product
    prodAll_dnk{i,2}= selected_count_dnk; % rows,columns...I save the position of the max number of the found product
    
    pos_conti_dnk = max_prod_dnk == column_val_dnk; %I find the position of n product
    selected_conti_dnk = column_cont_dnk(pos_conti_dnk); % I know the max number of the found product
    prodAll_dnk{i,3}= selected_conti_dnk; % rows,columns...I save the position of the max number of the found product
    
    pos_user_dnk = max_prod_dnk == column_val_dnk; %I find the position of n product
    selected_user_dnk = column_user_dnk(pos_user_dnk); % I know the max number of the found product
    prodAll_dnk{i,4}= selected_user_dnk; % rows,columns...I save the position of the max number of the found product      
end
mainSupDNK = [prodAll_dnk prod_dnk];
mainSupDNK = cell2table(mainSupDNK);
mainSupDNK.Properties.VariableNames = {'value' 'country_origin' 'continent_origin' 'item_origin' 'country_user'};
writetable(mainSupDNK,'largestSuppliers.xlsx', 'Sheet',6);


%% SWEDEN
prod_swe = unique(SWE.item_origin); %43 items
n = length(prod_swe); %43 items
 
column_pro_swe = SWE.item_origin; %column for products
column_cont_swe = SWE.continent_origin; %column for continent
column_country_swe = SWE.country_origin; %column for countries
column_user_swe = SWE.country_user; 
% countries_swe = SWE.sort_item3 %column for countries 
column_val_swe = SWE.value; % column for value
prodAll_swe = cell(n,2);
 
for i = 1:n
    pos_prod_swe = strcmp(column_pro_swe, prod_swe{i}); %I find the position of n product
    max_prod_swe = max(column_val_swe(pos_prod_swe)); % I know the max number of the found product
    prodAll_swe{i,1}= max_prod_swe; % rows,columns...I save the position of the max number of the found product
    
    pos_country_swe = max_prod_swe == column_val_swe; %I find the position of n product
    selected_count_swe = column_country_swe(pos_country_swe); % I know the max number of the found product
    prodAll_swe{i,2}= selected_count_swe; % rows,columns...I save the position of the max number of the found product
    
    pos_conti_swe = max_prod_swe == column_val_swe; %I find the position of n product
    selected_conti_swe = column_cont_swe(pos_conti_swe); % I know the max number of the found product
    prodAll_swe{i,3}= selected_conti_swe; % rows,columns...I save the position of the max number of the found product
    
    pos_user_swe = max_prod_swe == column_val_swe; %I find the position of n product
    selected_user_swe = column_user_swe(pos_user_swe); % I know the max number of the found product
    prodAll_swe{i,4}= selected_user_swe; % rows,columns...I save the position of the max number of the found product      
end
mainSupSWE = [prodAll_swe prod_swe];
mainSupSWE = cell2table(mainSupSWE);
mainSupSWE.Properties.VariableNames = {'value' 'country_origin' 'continent_origin' 'item_origin' 'country_user'};
writetable(mainSupSWE,'largestSuppliers.xlsx', 'Sheet',7);

%% POLAND
prod_pol = unique(POL.item_origin); %43 items
n = length(prod_pol); %43 items
 
column_pro_pol = POL.item_origin; %column for products
column_cont_pol = POL.continent_origin; %column for continent
column_country_pol = POL.country_origin; %column for countries
column_user_pol = POL.country_user; 
% countries_pol = POL.sort_item3 %column for countries 
column_val_pol = POL.value; % column for value
prodAll_pol = cell(n,2);
 
for i = 1:n
    pos_prod_pol = strcmp(column_pro_pol, prod_pol{i}); %I find the position of n product
    max_prod_pol = max(column_val_pol(pos_prod_pol)); % I know the max number of the found product
    prodAll_pol{i,1}= max_prod_pol; % rows,columns...I save the position of the max number of the found product
    
    pos_country_pol = max_prod_pol == column_val_pol; %I find the position of n product
    selected_count_pol = column_country_pol(pos_country_pol); % I know the max number of the found product
    prodAll_pol{i,2}= selected_count_pol; % rows,columns...I save the position of the max number of the found product
    
    pos_conti_pol = max_prod_pol == column_val_pol; %I find the position of n product
    selected_conti_pol = column_cont_pol(pos_conti_pol); % I know the max number of the found product
    prodAll_pol{i,3}= selected_conti_pol; % rows,columns...I save the position of the max number of the found product
    
    pos_user_pol = max_prod_pol == column_val_pol; %I find the position of n product
    selected_user_pol = column_user_pol(pos_user_pol); % I know the max number of the found product
    prodAll_pol{i,4}= selected_user_pol; % rows,columns...I save the position of the max number of the found product      
end
mainSupPOL = [prodAll_pol prod_pol];
mainSupPOL = cell2table(mainSupPOL);
mainSupPOL.Properties.VariableNames = {'value' 'country_origin' 'continent_origin' 'item_origin' 'country_user'};
writetable(mainSupPOL,'largestSuppliers.xlsx', 'Sheet',8);

%% ITALY
prod_ita = unique(ITA.item_origin); %43 items
n = length(prod_ita); %43 items
 
column_pro_ita = ITA.item_origin; %column for products
column_cont_ita = ITA.continent_origin; %column for continent
column_country_ita = ITA.country_origin; %column for countries
column_user_ita = ITA.country_user; 
% countries_ita = ITA.sort_item3 %column for countries 
column_val_ita = ITA.value; % column for value
prodAll_ita = cell(n,2);
 
for i = 1:n
    pos_prod_ita = strcmp(column_pro_ita, prod_ita{i}); %I find the position of n product
    max_prod_ita = max(column_val_ita(pos_prod_ita)); % I know the max number of the found product
    prodAll_ita{i,1}= max_prod_ita; % rows,columns...I save the position of the max number of the found product
    
    pos_country_ita = max_prod_ita == column_val_ita; %I find the position of n product
    selected_count_ita = column_country_ita(pos_country_ita); % I know the max number of the found product
    prodAll_ita{i,2}= selected_count_ita; % rows,columns...I save the position of the max number of the found product
    
    pos_conti_ita = max_prod_ita == column_val_ita; %I find the position of n product
    selected_conti_ita = column_cont_ita(pos_conti_ita); % I know the max number of the found product
    prodAll_ita{i,3}= selected_conti_ita; % rows,columns...I save the position of the max number of the found product
    
    pos_user_ita = max_prod_ita == column_val_ita; %I find the position of n product
    selected_user_ita = column_user_ita(pos_user_ita); % I know the max number of the found product
    prodAll_ita{i,4}= selected_user_ita; % rows,columns...I save the position of the max number of the found product      
end
mainSupITA = [prodAll_ita prod_ita];
mainSupITA = cell2table(mainSupITA);
mainSupITA.Properties.VariableNames = {'value' 'country_origin' 'continent_origin' 'item_origin' 'country_user'};
writetable(mainSupITA,'largestSuppliers.xlsx', 'Sheet',9);

%% UK
prod_gbr = unique(GBR.item_origin); %43 items
n = length(prod_gbr); %43 items
 
column_pro_gbr = GBR.item_origin; %column for products
column_cont_gbr = GBR.continent_origin; %column for continent
column_country_gbr = GBR.country_origin; %column for countries
column_user_gbr = GBR.country_user; 
% countries_gbr = GBR.sort_item3 %column for countries 
column_val_gbr = GBR.value; % column for value
prodAll_gbr = cell(n,2);
 
for i = 1:n
    pos_prod_gbr = strcmp(column_pro_gbr, prod_gbr{i}); %I find the position of n product
    max_prod_gbr = max(column_val_gbr(pos_prod_gbr)); % I know the max number of the found product
    prodAll_gbr{i,1}= max_prod_gbr; % rows,columns...I save the position of the max number of the found product
    
    pos_country_gbr = max_prod_gbr == column_val_gbr; %I find the position of n product
    selected_count_gbr = column_country_gbr(pos_country_gbr); % I know the max number of the found product
    prodAll_gbr{i,2}= selected_count_gbr; % rows,columns...I save the position of the max number of the found product
    
    pos_conti_gbr = max_prod_gbr == column_val_gbr; %I find the position of n product
    selected_conti_gbr = column_cont_gbr(pos_conti_gbr); % I know the max number of the found product
    prodAll_gbr{i,3}= selected_conti_gbr; % rows,columns...I save the position of the max number of the found product
    
    pos_user_gbr = max_prod_gbr == column_val_gbr; %I find the position of n product
    selected_user_gbr = column_user_gbr(pos_user_gbr); % I know the max number of the found product
    prodAll_gbr{i,4}= selected_user_gbr; % rows,columns...I save the position of the max number of the found product      
end

mainSupGBR = [prodAll_gbr prod_gbr];
mainSupGBR = cell2table(mainSupGBR);
mainSupGBR.Properties.VariableNames = {'value' 'country_origin' 'continent_origin' 'item_origin' 'country_user'};
writetable(mainSupGBR,'largestSuppliers.xlsx', 'Sheet',10);

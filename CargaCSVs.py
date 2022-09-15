
def crear_CSVs():
    import pandas as pd
    dataframe = pd.read_csv("Datasets/circuits.csv",encoding='UTF-8')
    dataframe.to_csv("Datasets/CSVs/circuits.csv",encoding='UTF-8',index=False,sep=';')

    dataframe = pd.read_json("Datasets/constructors.json",lines=True,encoding='UTF-8')
    dataframe.to_csv("Datasets/CSVs/constructors.csv",encoding='UTF-8',index=False)

    #https://stackoverflow.com/questions/38231591/split-explode-a-column-of-dictionaries-into-separate-columns-with-pandas
    dataframe = pd.read_json("Datasets/drivers.json",lines=True,encoding='UTF-8')
    dataframe = pd.concat([dataframe.drop(['name'], axis=1), dataframe['name'].apply(pd.Series)], axis=1)
    new_cols = ["driverId",	"driverRef"	,"number",	"code","forename",	"surname",	"dob",	 "nationality",	"url"]
    dataframe = dataframe.reindex(columns=new_cols)
    dataframe.to_csv("Datasets/CSVs/drivers.csv",encoding='UTF-8',index=False,sep=';')

    dataframe = pd.read_json("Datasets/pit_stops.json",encoding='UTF-8')
    dataframe.to_csv("Datasets/CSVs/pit_stops.csv",encoding='UTF-8',index=False)

    dataframe = pd.read_csv("Datasets/races.csv",encoding='UTF-8')
    dataframe.to_csv("Datasets/CSVs/races.csv",encoding='UTF-8',index=False)

    dataframe = pd.read_json("Datasets/results.json",lines=True,encoding='UTF-8')
    dataframe.to_csv("Datasets/CSVs/results.csv",encoding='UTF-8',index=False)

    #https://datatofish.com/union-pandas-dataframes/
    dataframe1 = pd.read_json("Datasets/Qualifying/qualifying_split_1.json",encoding='UTF-8')
    dataframe2 = pd.read_json("Datasets/Qualifying/qualifying_split_2.json",encoding='UTF-8')
    dataframe = pd.concat([dataframe1, dataframe2])
    dataframe.to_csv("Datasets/CSVs/Qualifying.csv",encoding='UTF-8',index=False)

    # https://www.statology.org/pandas-rename-columns/
    df1 = pd.read_csv("Datasets/lap_times/lap_times_split_1.csv",encoding='UTF-8',header=None)
    df2 = pd.read_csv("Datasets/lap_times/lap_times_split_2.csv",encoding='UTF-8',header=None)
    df3 = pd.read_csv("Datasets/lap_times/lap_times_split_3.csv",encoding='UTF-8',header=None)
    df4 = pd.read_csv("Datasets/lap_times/lap_times_split_4.csv",encoding='UTF-8',header=None)
    df5 = pd.read_csv("Datasets/lap_times/lap_times_split_5.csv",encoding='UTF-8',header=None)
    df = pd.concat([df1, df2,df3,df4,df5])
    df.rename(columns = {0:'raceId',1:'driverId',2:'lap',3:'position',4:'time',5:'miliseconds'}, inplace = True)
    df.to_csv("Datasets/CSVs/LapTimes.csv",encoding='UTF-8',index=False)
#cargar paquetes----
#cargar paquetes----
#cargar paquetes----
library(openxlsx)

#PARTE 1----------------------------------------------------------------------------------------------
#Cargar la data base
data_balances<- as_tibble(read.xlsx("data/balances_2014.xlsx"))
data_balances
dim(data_balance)

#se determina si existen valores faltantes
sum(is.na(data_balances))

#se realiza la limpieza de los datos 

n_columnas <- ncol(data_balances)
for (i in 1:n_columnas) {
  data_balances_limpio <- data_balances[!is.na(data_balances[, i]), ]
}
dim(data_balances_limpio)

#1
empresas<- as_tibble(data_balances_limpio)

#seleccionar las columnas solicitadas
empresas<-mutate(empresas,Liquidez_corriente=v345/v539,
                       Endeudamiento_del_activo=v599/v499,
                       Endeudamiento_patrimonial=v599/v698,
                       Endeudamiento_del_Activo_Fijo=v698/v498,
                       Apalancamiento=v539/v499)

#seleccionar las columnas solicitadas
empresas <- select(empresas,nombre_cia , situacion, tipo, pais, 
                   provincia, canton, ciudad, ciiu4_nivel1, ciiu4_nivel6,
                   Liquidez_corriente,Endeudamiento_del_activo,Endeudamiento_patrimonial,
                   Endeudamiento_del_Activo_Fijo,Apalancamiento)

#Renombrar las columnas
empresas<- rename(empresas, Empresas = nombre_cia,
                  Status = situacion,
                  Tipo_de_empresa= tipo,
                  País= pais,
                  Provincia= provincia,
                  Cantón= canton, 
                  Ciudad=  ciudad, 
                  Actividad_económica= ciiu4_nivel1, 
                  Subactividad= ciiu4_nivel6) 


empresas

#2
data_2<- as_tibble(read.xlsx("data/ciiu.xlsx"))
data_2<- data_2 %>% filter(CODIGO=="A" | CODIGO=="B" | CODIGO=="C"| CODIGO=="D"|CODIGO=="E"|
                  CODIGO=="F"|CODIGO=="G"|CODIGO=="H"|CODIGO=="I"|CODIGO=="J"|CODIGO=="K"|
                    CODIGO=="L"|CODIGO=="M"|CODIGO=="N"|CODIGO=="O"|CODIGO=="P"|CODIGO=="Q"|
                    CODIGO=="R"|CODIGO=="S"|CODIGO=="T"|CODIGO=="U"|CODIGO=="Z")
data_2<-data_2 %>%select(CODIGO,DESCRIPCION)

data_3<-empresas %>% select(Actividad_económica)
tabla1<-data_3 %>% group_by(Actividad_económica) %>% summarise(Ntotal_emp_Actividad_eco=n()) %>%
        left_join(data_2,by=c("Actividad_económica"="CODIGO"))  
tabla1<-select(tabla1,Actividad_económica,DESCRIPCION,Ntotal_emp_Actividad_eco)
tabla1 

tabla2<-empresas%>% group_by(Actividad_económica,Cantón) %>% summarise(Ntotal_empresas_ecoycanton=n()) %>% 
     left_join(data_2,by=c("Actividad_económica"="CODIGO"))
tabla2<-select(tabla2,Actividad_económica,DESCRIPCION,Cantón,Ntotal_empresas_ecoycanton)
tabla2

#3  

ggplot(empresas, aes(x =Provincia, y = Liquidez_corriente,fill=Status)) +
  geom_bar(stat = "summary", position = "stack")+ 
  labs(title = "Comparativo de Liquidez_corriente por Status y Provincia",
       x = "Provincia", y = "Liquidez_corriente") +
theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(empresas, aes(x =Provincia, y = Endeudamiento_del_activo,fill=Status)) +
  geom_bar(stat = "summary", position = "stack") +
  labs(title = "Comparativo de Endeudamiento del activo por Status y Provincia",
       x = "Provincia", y = "Endeudamiento del activo") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(empresas, aes(x =Provincia, y = Endeudamiento_patrimonial,fill=Status)) +
  geom_bar(stat = "summary", position = "stack") +
  labs(title = "Comparativo de Endeudamiento patrimonial por Status y Provincia",
       x = "Provincia", y = "Endeudamiento patrimonial") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(empresas, aes(x =Provincia, y = Endeudamiento_del_Activo_Fijo,fill=Status)) +
  geom_bar(stat = "summary", position = "stack") +
  labs(title = "Comparativo de Endeudamiento_del_Activo_Fijo por Status y Provincia",
       x = "Provincia", y = "Endeudamiento_del_Activo_Fijo") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(empresas, aes(x =Provincia, y = Apalancamiento,fill=Status)) +
  geom_bar(stat = "summary", position = "stack") +
  labs(title = "Comparativo de Apalancamiento por Status y Provincia",
       x = "Provincia", y = "Apalancamiento") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#4
ggplot(empresas, aes(x = Tipo_de_empresa)) +
 geom_line(aes(y = Liquidez_corriente, group = 1, color = "Liquidez Corriente"), 
            stat = "summary", fun = "mean", position = "dodge", size = 1) +
  geom_point(aes(y = Liquidez_corriente, group = 1, color = "Liquidez Corriente"), 
            stat = "summary", fun = "mean", position = "dodge", size = 3) +
  geom_line(aes(y = Endeudamiento_del_activo, group = 1, color = "Endeudamiento del Activo"), 
            stat = "summary", fun = "mean", position = "dodge", size = 1) +
  geom_point(aes(y = Endeudamiento_del_activo, group = 1, color = "Endeudamiento del Activo"), 
            stat = "summary", fun = "mean", position = "dodge", size = 3)+
  geom_line(aes(y = Endeudamiento_patrimonial, group = 1, color = "Endeudamiento Patrimonial"), 
            stat = "summary", fun = "mean", position = "dodge", size = 1) +
  geom_line(aes(y = Endeudamiento_del_Activo_Fijo, group = 1, color = "Endeudamiento del Activo Fijo"), 
            stat = "summary", fun = "mean", position = "dodge", size = 1) +
  geom_line(aes(y = Apalancamiento, group = 1, color = "Apalancamiento"), 
            stat = "summary", fun = "mean", position = "dodge", size = 1) +
  geom_point(aes(y = Endeudamiento_patrimonial, group = 1, color = "Endeudamiento Patrimonial"), 
            stat = "summary", fun = "mean", position = "dodge", size = 3) +
  geom_point(aes(y = Endeudamiento_del_Activo_Fijo, group = 1, color = "Endeudamiento del Activo Fijo"), 
            stat = "summary", fun = "mean", position = "dodge", size = 3) +
  geom_point(aes(y = Apalancamiento, group = 1, color = "Apalancamiento"), 
            stat = "summary", fun = "mean", position = "dodge", size = 3)+
  scale_color_manual(values = c("Liquidez Corriente" = "blue", 
                                "Endeudamiento del Activo" = "red", 
                                "Endeudamiento Patrimonial" = "green", 
                                "Endeudamiento del Activo Fijo" = "orange", 
                                "Apalancamiento" = "purple")) +
  theme_minimal() +
  labs(title = "Comparativo de los indicadores financieros de liquidez y solvencia por tipo de empresa",
       x = "Tipo de Empresa", y = "Valor",
       color = "Indicadores Financieros") +  # Cambiar el título de la leyenda
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
 


#PARTE 2----------------------------------------------------------------------------------------------

#Agrego las columnas con las que se necesita operar
empresas$trab_direc<-data_balances_limpio$trab_direc
empresas$tamanio<-data_balances_limpio$tamanio
empresas$trab_admin<-data_balances_limpio$trab_admin


#¿El endeudamiento del activo fue mayor en empresas micro + pequeñas vs. grandes?
PM<-empresas %>% select(tamanio,Endeudamiento_del_activo) %>% filter(tamanio=="PEQUEÑA" | tamanio=="MICRO") 
PM_limpio<-PM [ is.finite(PM$Endeudamiento_del_activo), ]
E_activo_PM<-sum(PM_limpio$Endeudamiento_del_activo, na.rm = TRUE)

G<-empresas %>% select(tamanio,Endeudamiento_del_activo) %>% filter(tamanio=="GRANDE") 
E_activo_G<-sum(G$Endeudamiento_del_activo, na.rm = TRUE)

RESULTADOS<-data.frame(
  Tipo_empresa = c("Micro + Pequeñas", "Grandes"),
  Endeudamiento=c(E_activo_PM,E_activo_G)
)

ggplot(RESULTADOS, aes(x = Tipo_empresa, y = Endeudamiento)) +
  geom_bar(stat = "identity", fill= "blue") +
  labs(title = "Endeudamiento del activo en empresas micro + pequeñas vs. grandes",
       x = "Tamaño empresa", y = "Endeudamiento del activo") +
  theme_minimal()

#¿La liquidez por tipo de compañía es diferente entre aquellas empresas que tienen más 
#de 60 trabajadores directos y que cuenta con 100 a 800 trabajadores administrativos?

LIQ_B<-empresas %>% select(Tipo_de_empresa,Liquidez_corriente,trab_direc) %>% 
  group_by(Tipo_de_empresa) %>% filter(trab_direc>=60) 
LIQ_B_limpio<- LIQ_B[ is.finite(LIQ_B$Liquidez_corriente), ]
ResB<-sum(LIQ_B_limpio$Liquidez_corriente)

LIQ_C<-empresas %>% select(Liquidez_corriente,trab_admin,Tipo_de_empresa) %>%
  group_by(Tipo_de_empresa)%>% filter(trab_admin >=100 & trab_admin <=800)
LIQ_C_limpio<- LIQ_C[ is.finite(LIQ_C$Liquidez_corriente), ]
ResC<-sum(LIQ_C_limpio$Liquidez_corriente)


L_RES<-data.frame(
  Filtros=c("Mayores o igual a 60 Trabajadores directos"," De 100 a 800 trabajadores administrativos "),
  liquidez_x_compañía= c(ResB, ResC)
  
)

ggplot(L_RES, aes(x = Filtros, y = liquidez_x_compañía)) +
  geom_bar(stat = "identity", fill= "blue") +
  labs(title = "Liquidez por tipo de compañía vs  empresas que tienen más 
de 60 trabajadores directos y que cuenta con 100 a 800 trabajadores administrativos",
       x = "", y = "Liquidez") +
  theme_minimal()

#Describe el top 10 de empresas con mayor apalancamiento.
TOP_APAL<-empresas %>% select(Empresas,Apalancamiento)
TOP_APAL_limpio<- TOP_APAL[ is.finite(TOP_APAL$Apalancamiento), ]

TOP_ordenados<-TOP_APAL_limpio %>% arrange(desc(Apalancamiento)) 
TOP_10<-head(TOP_ordenados,10)

ggplot(TOP_10, aes(x = reorder(Empresas,Apalancamiento), y = Apalancamiento)) +
  geom_bar(stat = "identity", fill= "blue") +
  labs(title = "Top 10 de empresas con mayor apalancamiento",
       x = "Empresas", y = "Apalancamiento") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))







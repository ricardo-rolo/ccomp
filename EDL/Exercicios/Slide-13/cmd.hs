data Cmd = Atr String Exp   -- atribuicao, ex.: x=1
         | Seq Cmd Cmd      -- sequencia,  ex.: x=1 ; y=x
    deriving Show

data Exp = Num Int
         | Add Exp Exp
         | Sub Exp Exp
         | Var String
         | Cnd Exp Cmd Cmd
         | Rep Exp Cmd
    deriving Show

type Mem = [(String,Int)]
memoria :: Mem
memoria = []

consulta :: Mem -> String -> Int
consulta [] id = 0
consulta ((id', v'):l) id = if id == id' then v' else consulta l id

escreve :: Mem -> String -> Int -> Mem
escreve mem id v = (id, v):mem

avaliaExp :: Mem -> Exp -> Int
avaliaExp mem (Num x) = x
avaliaExp mem (Add e1 e2) = (avaliaExp mem e1) + (avaliaExp mem e2)
avaliaExp mem (Sub e1 e2) = (avaliaExp mem e1) - (avaliaExp mem e2)
avaliaExp mem (Var x) = consulta mem x

avaliaCmd :: Mem -> Cmd -> Mem
avaliaCmd mem (Atr id e) = escreve mem id v
    where v = avaliaExp mem e
avaliaCmd mem (Seq c1 c2) = avaliaCmd mem' c2
    where mem' = avaliaCmd mem c1
avaliaCmd mem (Cnd exp c1 c2) = if (avaliaExp mem exp) /= 0 then (avaliaCmd mem c1) else (avaliaCmd mem c2)
avaliaCmd mem (Rep exp cmd) = if (avaliaExp mem exp) /= 0 then mem else avaliaCmd (avaliaCmd mem cmd) (Rep exp cmd) 

avaliaProg :: Cmd -> Int
avaliaProg cmd = avaliaExp (avaliaCmd [] cmd) (Var "ret")

c0 = Atr "x" (Num 1)
-- x = 1 + x - 20
c1 = Atr "x" (Sub (Add (Num 1) (Var "x")) (Num 20))
-- x = 1 ; y = 2 ; z = x+y
c2 = Seq (Atr "x" (Num 1)) (Seq (Atr "y" (Num 2)) (Atr "z" (Add (Var "x") (Var "y"))))

main = print (avaliaCmd memoria c0)
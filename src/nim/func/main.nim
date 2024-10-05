# 関数オーバーロード
proc toString(x: int): string = "Hello. This is num."
proc toString(x: bool): string = "Hello. This is bool."

echo 13.toString()
echo true.toString()

# 演算子オーバーロード
echo `+`(3, 4)

proc `+`(a: int, b: int): int = a * a * b * b

echo 10 + 20
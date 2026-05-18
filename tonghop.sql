USE products_management;

-- Viết câu lệnh cập nhật số lượng tồn kho của sản phẩm có id = 'p001'
START TRANSACTION;
	UPDATE products
	SET pro_stock = 10
	WHERE pro_id = 'p001';

DELIMITER //
CREATE PROCEDURE buy_products(IN pro_stock_in INT)
BEGIN
	DECLARE pro_stock_temp INT; -- Lấy ra số lượng tồn kho
    SET pro_stock_temp = (SELECT pro_stock FROM products WHERE pro_id = 'p001');
    
    START TRANSACTION;
		INSERT INTO orders -- Thêm đơn hàng mới
		VALUES(null, pro_stock_in, default, 'p001'); 
		
		IF pro_stock_in > pro_stock_temp -- Kiểm tra nếu đơn hàng có sl lớn hơn sl tồn kho
			THEN ROLLBACK; -- thì rollback
			ELSE COMMIT;
        END IF;
END //
DELIMITER ;

DROP procedure buy_products;
CALL buy_products(50);

-- Tạo thủ tục để thực hiện giao dịch mua sản phẩm, nếu như sau khi mua, số lượng sản phẩm
-- Trong kho nhỏ hơn 0, thì thực hiện rollback lại.
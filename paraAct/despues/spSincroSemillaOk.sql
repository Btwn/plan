u s e   [ i n t e l i s i s t m p ] 
 a l t e r   p r o c e d u r e   [ d b o ] . [ s p s i n c r o s e m i l l a o k ] 
 @ m o d u l o v a r c h a r ( 5 ) , 
 @ i d i n t , 
 @ m o v v a r c h a r ( 2 0 ) , 
 @ o k i n t o u t p u t , 
 @ o k r e f v a r c h a r ( 2 5 5 ) o u t p u t 
 a s   b e g i n 
 d e c l a r e 
 @ d e l i n t , 
 @ a l i n t , 
 @ s u c u r s a l p r i n c i p a l i n t , 
 @ v a l i d a r s i n c r o s e m i l l a b i t , 
 @ s e g u i m i e n t o v a r c h a r ( 2 0 ) , 
 @ o r i g e n t i p o v a r c h a r ( 1 0 ) 
 s e l e c t   @ v a l i d a r s i n c r o s e m i l l a   =   v a l i d a r s i n c r o s e m i l l a ,   @ s u c u r s a l p r i n c i p a l   =   s u c u r s a l   f r o m   v e r s i o n   i f   @ v a l i d a r s i n c r o s e m i l l a   =   1 
 b e g i n 
 i f   @ s u c u r s a l p r i n c i p a l   =   0   s e l e c t   @ d e l   =   0   e l s e   s e l e c t   @ d e l   =   5 0 0 0 0 0 0 0   +   ( @ s u c u r s a l p r i n c i p a l   *   7 0 0 0 0 0 0 ) 
 s e l e c t   @ a l   =   7 0 0 0 0 0 0 0   +   ( (   @ s u c u r s a l p r i n c i p a l   +   1 )   *   7 0 0 0 0 0 0 ) 
 i f   n o t   ( @ i d   b e t w e e n   @ d e l   a n d   @ a l - 1 ) 
 b e g i n 
 e x e c   s p s u c u r s a l m o v s e g u i m i e n t o   @ s u c u r s a l p r i n c i p a l ,   @ m o d u l o ,   @ m o v ,   @ s e g u i m i e n t o   o u t p u t 
 i f   n o t   ( @ s e g u i m i e n t o   =   ' m a t r i z '   a n d   @ s u c u r s a l p r i n c i p a l   =   0 ) 
 b e g i n 
 e x e c   s p m o v i n f o   @ i d ,   @ m o d u l o ,   @ o r i g e n t i p o   =   @ o r i g e n t i p o   o u t p u t 
 i f   @ o r i g e n t i p o   < >   ' e / c o l l a b ' 
 s e l e c t   @ o k   =   7 2 0 7 0 ,   @ o k r e f   =   c o n v e r t ( v a r c h a r ,   @ i d ) 
 e n d 
 e n d 
 e n d 
 e n d 
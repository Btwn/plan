u s e   [ i n t e l i s i s t m p ] 
 a l t e r   p r o c e d u r e   [ d b o ] . [ s p m o v c o p i a r a n e x o s ]   @ s u c u r s a l   i n t , 
 @ o m o d u l o   c h a r ( 5 ) , 
 @ o i d   i n t , 
 @ d m o d u l o   c h a r ( 5 ) , 
 @ d i d   i n t , 
 @ c o p i a r b i t a c o r a   b i t   =   0 
 a s 
 b e g i n 
 i f   @ o m o d u l o   i s   n o t   n u l l 
 a n d   @ o i d   i s   n o t   n u l l 
 a n d   @ d m o d u l o   i s   n o t   n u l l 
 a n d   @ d i d   i s   n o t   n u l l 
 b e g i n 
 i n s e r t   a n e x o m o v   ( s u c u r s a l ,   r a m a ,   i d ,   n o m b r e ,   d i r e c c i o n ,   i c o n o ,   t i p o ,   o r d e n ,   c o m e n t a r i o ) 
 s e l e c t 
 @ s u c u r s a l , 
 @ d m o d u l o , 
 @ d i d , 
 n o m b r e , 
 d i r e c c i o n , 
 i c o n o , 
 t i p o , 
 o r d e n , 
 c o m e n t a r i o 
 f r o m   a n e x o m o v   w i t h   ( n o l o c k ) 
 w h e r e   r a m a   =   @ o m o d u l o 
 a n d   i d   =   @ o i d 
 a n d   n o m b r e   < >   ' c o m p r o b a n t e   f i s c a l   d i g i t a l ' 
 i f   @ o m o d u l o   i n   ( ' v t a s ' ,   ' i n v ' ,   ' c o m s ' ,   ' p r o d ' ) 
 a n d   @ d m o d u l o   i n   ( ' v t a s ' ,   ' i n v ' ,   ' c o m s ' ,   ' p r o d ' ) 
 i n s e r t   a n e x o m o v d   ( s u c u r s a l ,   r a m a ,   i d ,   c u e n t a ,   n o m b r e ,   d i r e c c i o n ,   i c o n o ,   t i p o ,   o r d e n ,   c o m e n t a r i o ) 
 s e l e c t 
 @ s u c u r s a l , 
 @ d m o d u l o , 
 @ d i d , 
 c u e n t a , 
 n o m b r e , 
 d i r e c c i o n , 
 i c o n o , 
 t i p o , 
 o r d e n , 
 c o m e n t a r i o 
 f r o m   a n e x o m o v d   w i t h   ( n o l o c k ) 
 w h e r e   r a m a   =   @ o m o d u l o 
 a n d   i d   =   @ o i d 
 i f   @ c o p i a r b i t a c o r a   =   1 
 i n s e r t   m o v b i t a c o r a   ( s u c u r s a l ,   m o d u l o ,   i d ,   f e c h a ,   e v e n t o ,   u s u a r i o ,   a g e n t e ,   c l a v e ) 
 s e l e c t 
 @ s u c u r s a l , 
 @ d m o d u l o , 
 @ d i d , 
 f e c h a , 
 e v e n t o , 
 u s u a r i o , 
 a g e n t e , 
 c l a v e 
 f r o m   m o v b i t a c o r a   w i t h   ( n o l o c k ) 
 w h e r e   m o d u l o   =   @ o m o d u l o 
 a n d   i d   =   @ o i d 
 i f   @ o m o d u l o   =   ' v t a s ' 
 a n d   @ d m o d u l o   =   ' v t a s ' 
 b e g i n 
 i n s e r t   v e n t a d a g e n t e   ( i d ,   r e n g l o n ,   r e n g l o n s u b ,   a g e n t e ,   f e c h a ,   h o r a d ,   h o r a a ,   m i n u t o s ,   a c t i v i d a d ,   e s t a d o ,   c o m e n t a r i o s ,   c a n t i d a d e s t a n d a r ,   c o s t o a c t i v i d a d ,   f e c h a c o n c l u s i o n ) 
 s e l e c t 
 @ d i d , 
 r e n g l o n , 
 r e n g l o n s u b , 
 a g e n t e , 
 f e c h a , 
 h o r a d , 
 h o r a a , 
 m i n u t o s , 
 a c t i v i d a d , 
 e s t a d o , 
 c o m e n t a r i o s , 
 c a n t i d a d e s t a n d a r , 
 c o s t o a c t i v i d a d , 
 f e c h a c o n c l u s i o n 
 f r o m   v e n t a d a g e n t e   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ o i d 
 i n s e r t   v e n t a e n t r e g a   ( i d ,   s u c u r s a l ,   e m b a r q u e ,   e m b a r q u e f e c h a ,   e m b a r q u e r e f e r e n c i a ,   r e c i b o ,   r e c i b o f e c h a ,   r e c i b o r e f e r e n c i a , 
 d i r e c c i o n ,   d i r e c c i o n n u m e r o ,   d i r e c c i o n n u m e r o i n t ,   c o d i p o s t a l ,   d e l e g a c i o n ,   c o l o n i a ,   p o b l a c i o n ,   e s t a d o ,   t e l e f o n o ,   t e l e f o n o m o v i l ) 
 s e l e c t 
 @ d i d , 
 @ s u c u r s a l , 
 e m b a r q u e , 
 e m b a r q u e f e c h a , 
 e m b a r q u e r e f e r e n c i a , 
 r e c i b o , 
 r e c i b o f e c h a , 
 r e c i b o r e f e r e n c i a , 
 d i r e c c i o n , 
 d i r e c c i o n n u m e r o , 
 d i r e c c i o n n u m e r o i n t , 
 c o d i p o s t a l , 
 d e l e g a c i o n , 
 c o l o n i a , 
 p o b l a c i o n , 
 e s t a d o , 
 t e l e f o n o , 
 t e l e f o n o m o v i l 
 f r o m   v e n t a e n t r e g a   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ o i d 
 i n s e r t   i n t o   v e n t a v a l e m a v i   ( i d ,   v a l e ) 
 s e l e c t 
 @ d i d , 
 v v . v a l e 
 f r o m   v e n t a v a l e m a v i   v v   w i t h   ( n o l o c k ) 
 w h e r e   i d   =   @ o i d 
 e n d 
 e n d 
 e n d 
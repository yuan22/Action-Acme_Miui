#!/bin/sh
skip=44

tab='	'
nl='
'
IFS=" $tab$nl"

umask=`umask`
umask 77

gztmpdir=
trap 'res=$?
  test -n "$gztmpdir" && rm -fr "$gztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

if type mktemp >/dev/null 2>&1; then
  gztmpdir=`mktemp -dt`
else
  gztmpdir=/tmp/gztmp$$; mkdir $gztmpdir
fi || { (exit 127); exit 127; }

gztmp=$gztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$gztmp" && rm -r "$gztmp";;
*/*) gztmp=$gztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `echo X | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | gzip -cd > "$gztmp"; then
  umask $umask
  chmod 700 "$gztmp"
  (sleep 5; rm -fr "$gztmpdir") 2>/dev/null &
  "$gztmp" ${1+"$@"}; res=$?
else
  echo >&2 "Cannot decompress $0"
  (exit 127); res=127
fi; exit $res
��f�a1.sh �|y<�����=Ɩ�bBk�-�hdߢd'ƾ���5c'K)%YJ�"�B�&"K�DD���,5y>����y^���5s��>�\�9�z��\�p��	
!\����p�*�P��`r�}�7�B�dDz���oJ����	��M@��P"J���:�7�@��@_�P���8�@�x��#����vp�>�.�[��c��g7Մ�M���p
��-8����FC��;#����_xj�/o�zY��K��vsG��H��;���<��D��dDd�D��D%�>1�uO��no"���(o�V*Lu;������s��v �)��	�&$� �$ ƍϧC�z�]�[[�uU����)�d��_p�=p(��}��o�.�~f��w\w<x�y�d\q�z�������=�K{��{������i����O�/b��=����п�����NU��|�i|�0����mw�`\:��P��BC��}Q��s������������9���~h;77�sv(w�����C�:�{C��ݽ@��������l�|}=�l ���<�!��h'� ,��������0rr����E�� �~{�dgs�i�
q�ء����2/_@
�鋶�Cy�x�|��T��!'t��5l$Ee�$�~'��$E�!6ڦz6�3N�(?�������������;X�^���lp����d$�oR���?pvåȉ��:�F����0
E�l�x,#-��k�3c夐}P�ω����{�&�[Z�8څ��8�o�����(~~&\�D8>C���KD8;�A�s��MN4�c� �y��|>�Dkv'�I�p9"���\"���I����D8%nA��#���&�]�p"ܛ��AD8-�<L���qD8�J�3�W�p��,�g"�pf"��g!�Dx�F�w���#�I�^Q_��	�,,p2�	M�ӏ�j�j��HK2�!;�R�7=�*�y�dv|���A�B��X�ȃ]g�	�s�<8f+��~���l>��y��̦by����E,��𠻳�X~��!4k���@�2��X~���2����@�"��X~���1��� v�Y,���P��`�Z�����6�?yl�X����c��ߏ���<6~,������|<ȳ`��m.��.ژk$f�i��T7���;2�v�$ʌ �a9ج��hb�����2��&@��H��hZa&\��Z팟����[������Q�]��=6�m�ټM��,!�g�#�ȁm4;���~\�00ý򻨬>��!��; K�2A��fh��g��W9���[#ȷ�s�x@u��s��� �� �&� h�`0� ��c氤���vġ��1@FH{,�	GފӮHt�g�U+X :����L@� 1���A��,\���0b CF�X��f	Ŋ���8r\�.8��롟0��Mb	���f �z`��.��B�E�Z����-F�t8����;�*��D+b��f�0��}�2Pw��8�Gx|IT�'}
 �#���o���e�"FTz�(q5����N�^���Qh'E�CS%�v�8s~Q��؈E��r!�u�b髩�rq��"8�D3��1 ��(�OP\�G�b���
�S��;Gd?x��/фL�G32!"1#HL��0��4S?���h�'�Zp�6`��&��5�Ƹ�`�~g��6�".!����\ ��p~� .rp��@R�|$�p�.|���5~��<������<��&�I���yFh``"�_�'+�
�A�a;fv&��K�o�q�!�b��`��_��KC`������ߪrf��� �Q@8#���X�U�D��$Ԃ��c:��\!fЀF�_  �t�$�5��7P�c6�L�X�� ���Dځ+��ό��` ��(3��B��M�rQ���o�'V+	�J��J�IJ�	�`И$�(��r�ʚ��W���8���X�W���Ϥ^,��ƀuI�q��+(���ĺ6���oc `��A���	X��G�JO2$䆄� sv�00%�z�HL/60�L?0��ɱ�{wW�� t%|�� w@��zU�#*��A�}d�� 4x�7�|�e�0��Q�͵�mH�����A��F�y�u���`�"�f @�5@�]FY��� ���� `��+~  ��!pDp
�bjm�V�"�ȷ��(Hg���j\.�@�`9�8`B �@��@�柂?�@�� 1 \#�A��?�{ 4jq��sp�U^���;;��7�A��p����*`:	UJA�M`u�D���{`<��m��f �Ը��O.C�hj蟦`k�@�Q�b�� �� wl�v���&���{� l�|�|�;f�B8����?�;x �8@���.T@|r�w�`�@፳@+j����
�Y����{_�k`�T�A��4�J��!�Ol�Qn�ff��%�tl�f��ܒ���F��8s��f�pO
h��$C(Ƭ�����hpX�G	�h1��d�|��(���>"���XI�����8���V��x��a�	�!`� 0��y�D/ְ�/�
d�?���׫���P����GvB~s���	�a�
Μ�A�ڐ���I���0��,�?�m�$*�� 4��4�PcH���&*�JH��,��)�I��v�a�LH�ҏf��a�ࢻ
��m�I��A����>��hO������yE�1��0@�h�8�p}F��	v,E�1X�����������ƼR3S����Ȱ��" 5Q����|���>�5�"��\@�,��o�ߺ�M]�wM̢��[dT+)��|���R;�f�f�fӚ��~�����䑘$f��|f��}2$�g�v	��݃ ����p~G��;@l ��
�����u���{z���l��^�n~�%OwwD�����~�(�b4��<nygC@���	PW��s6��g~ ��]�qgPk`B��0���� ���~����A��bܧ�;�w� �^h@��7?���c4����J�R20���m��=G��>ׯX���cТc?IOHur�SQ��!�=���3�>h{�l�{�5:�XZ
��@	8�p������+����u���|��L��3��o�O%P�6�����>+���HN�
*���:�%��:��g��o�|2"9"��4����:���_;q'I��Hj@%���.@�i���1���ӱ'�"��Id�t���H:�X
$�\���/������:���騰����C�k��8������aߔ�O
���#aO���G؋[�or�����=N�X �Y�e쒯m�xa����Fؓ��'{��x9aO����ў+ˮ�{�<~������&aO�	��x��~/��]�s�X��������|>��?r\�x^
/���I��?�w���w|ES�+�O�TO������� <���,<-��j<���<����xJ�x*��2x��?���������\?�5�B��)���@&i�踼xos
y��rł�z��{�rC���	��O/�)�:�&u���������a�Y�ڡ�%��#��1߾*4��0bL]��c�=�Ϙ�k���P�D����K��y*��5<�f�Muc�z�Zyw�j�.�|������l�n�ų<Lͫ�����I+����cu?r��������5���^�����(�p�t|��u�g�z(��p�����Ϧ]�Fq>�4:�<�=ul��?.����9��+��ɾ.�
������o|������#���'�S_33�rHƖ��涎�y�Dރ}����-*'����jg�� ��˷ь�'o�}HT���]��u��=�52Q)9��G�$��HWON�4��n�R�|z����m�E�x;:��H���.e��f�m���Ys�P�#k����-���["R���-�.�,qN<��'~ƒ���k�U�m�Y��U���EG�Ǡ�	�12�=_3�a.�o4ݢ{��1�K�緶������q�V���
m�R9jM��G����&`sy�˸|��8�Sf��Exw	�����Ezt��������Aj�'�$��U�xO�϶Je��CohE��]��WA��U��E?$�;�&�9��ߝ�d��z��MW�U��\ya����&�ANm��k�h������ꛝ>��ny��P1���r*����-s�$�Pu���Г��G~,z}���E�P�z��=�\щRR�!O4�Ǣ�zW�(3Et�^�z5m�c{u\��)���x[�"�������%þ[�W1;mrU'|��ެZi�Q�����V���+��RfZ����'x9�S��x�W�כ^7PC6�%/�X��?Q~��TY���̢�un�`}}�����'Iל��ЧQ0�������c�3Ec�b�#�ٹ�4'�)�M�^�'�u���HF�����F�n���#����r*��'~�':�{l!@���pff�}Шvq��"�wrk}C�ES����,�;ӆ��j?�+T����#�������-�N杷w6�I�e��;L����:���%W�(8τ>{,|r4�k{GS��d�`Wbi�8S��RLy�S�K���"�u5�r<��/;؏��:l�S�z@ȑ���Gq������F���}ٵ}��|��ig��ԏ��9�gׇtu����˅�䐑���B_�@�YS�7�_7~�V�l�MO�=
���rE�wBt߃�Ύ4�4�Pui�_�<�K�Y*u�G��m���J���t.��k��O�1����Qz�p����M��R��rh�C�2���͂W�ʆ[~y�Kog�RW��(8���w4S���*	6���{My�Ab����w\#Fr4?�>t[r"��&ytm7tGG��~Ȓ��`~T�/�}�����t��a�����b1�<^R���[�v.Z�|�R���ߧ��8}G�����)]��-|ju�G��h�?�҇o{��:�Q���?��k}�ބ��\�RO�*�TB)%�l��4�B��Ur��7���'^��ם���!�e��guc��My���N����=�����><��x�nT]��=s�`��B��_=��Syb%q�JgMt�^����7в|?����QՓ��}�J�7�6B�Ï�#�9�!��rD�����eD�����+kEO��0�4�l����8��c�*��{����Q��W�C����r��P�&����y�ˎ�(�~�`X)3Wj`L�3~cz������~�R�=��!�]/��g�m��$��a̖���Zu�W3�i<��)�󍀲��1���}l����;�bW5i����|���Ȍ�ڳ������0>R�?�s���K�Z��W7�����cȥV�m錯���bj��y|��p9�������<�5v;��iufNsG�J����Z�I�̭��팴Ơ,/A�3.�tr�פ�0�r�۾�t���ZW�1����.�Zj*��f�����#�]�S1���6��Я*�KK�?C�>�xx|/0	|�Xm���r��,�`k��(���H�te7h�����ܮt��Mw!N�j��7r�{�f�+�C�5��7����0s���|��<���/_���ti������0ڛ7�?���߅攓\j����{_�~0�,/P�5��D��Km��H����5<j��+��ˆC�[F��Oތ��t��'EP��r3mN���=o�����pE*Q�����xp��k�j�y�i�TR���GX#>%�2�J�)�sd`��r���s���~���4�@��,i�J��Ӗp���|�4K��kI��%�!�j�`ٖB���8�/�����fw�=K��oe������Bh-����;�|T>9zv߹+q��Օ�ܸi5�E7�떅ASl�ɜ�n����Z�ڪ�9�<�d[.�sd��e�bv�/�Le�a��WJ��GES��O�06��H�����J~�i���tL�1��~o?������r�"���k�Tq'?A#_+k�}��l�8ۡ��l��/k�/-��8�y�*ivG��K+�i�	���0}�,�i�������)/N}gn{M�2���e9�}��yO�X0$I�^���,�a��}�D�p=0�v�vTZ4j�AJ�RrF�K���E��2�I.Sz��������G��7,�\Y�+�H�8�����n�H�L�D{���He�B-�Xt��V!��uv���U�w�C;�ߖ�O�B���#=���i�0��
>9xRsb4�]J�OC��9Y����~�:r�u�ێ�%��z��>��ƚ��K��Z֘
�ӗk�2G�_t܄]qH�㤀3u�[�ǜֺ�N���:�b7�x�VZ�-nz��\��̠��p)�t�A�6�;�����Ŭ�ĸ�3Ғ�����
ezsN54��A��1
�7}�F �����*�pz1;�C�f���o���0�~:��zH���q���G�s�kϫ���+e��î�g[�����|#}��t��?N���ᙊ�K0s��L�:���&ofV��S�ŧ-���͝R��xd甍�:����ж�������M���'���H�(-+ˈ\ؾk�v~��Q&9����G��8!�nI4���d��uH�:���b�76��(-�.��wo͇�i,�3��	%}����A9�}F��0�����M�W��e7|TS�yG��-���%0])�4v|i����p�c��Wke���YV��ˬ*�gdg�]��IG�h�p˗�g���3�V��cm�z�Jq�J�m?)���Ś���Q�Cݿ~��V(颭�7ka#��x��=��6w��J������B�z��j��O�`�b��M�.���^�p���Un��o��/���7}�:riU�sV�F0��1��u���'���������Iў�����<�?
.�X6ze��C�m�S�����:���>�8�}E>�in���X^��S�[���GGu��ڨ���>�P�U9�7��G�{�ݠֳ(tH{���mI�������޾�ٰE�Y⎢��Tu�:n7t̮Ct""I��i�d6	�S(�*g 0�:�4T��j#�z��gB>���.ڻ=�ݧ)i��ĶM5!������\:O���e��`܅!����ST�-�W��荲J�8���ǱJ�z�)�jl�����H����Z�KF"�i�$RU��}vV֢�S��_%[*�r+;���Һ�����2��5���dNIr��s��Ld�^�γ�%���-����Z�GM88�6I+t��l8�T�Fǘ�q��c>wZ�g׬����n�(�y?˝4|WG�r�N��ϳ5�h+~���:?����3F�0*]�x_��o5��l�l�����h��>�C~�3j�'{����w�������w���H�+;��S1�c�
VOb.M�o�zQ�?���W�k���:큀�K�#�PI���{�t=n��S�I<)0����8i�i�������_2���F6��ğ��|�&2T}�%���x�r�C8=�ԡ~q$��ˡ��;���ϥ3[qk@F��`EA�2���
��^�ȯd>:Il:���f���n�E��_�����A��{����ڙ�ә��wKKl�ߢݴcu>RD�����k��.���M���7�ԝ�����U#?.S�(�ɟ�9�I�[^��Doq���FdB��p���Հ.�Xcq�͹W�'W�1�לk���6�h� WT�]�����矚���\��G��t<볒3�D̙�1�?o�~s�Y�𐔴fһ��(8[�z�15Ȏ��tϱ��%4�ޗ��=��W����}z��������U�� �SӜ�&V�wIU����	sdC�H�I��<)\'P����$L�"���Y��ܔ;��\-,����G�C���'�8T���x��dXa9��0�9+����x�k�I�D��p��/�|DA͖~�Qx=Y<��N��`iƐǬ������3��?Up>�0:5��Q(�b�}�@�ſP��E�.����g���Km��#�m&��(ԣh����ܭ�}���'��-5f2}�Ͻ��t�s���p�N�G���j�����$i�=���˕��y�Vڝ�[:I��X���M�����3���U��9з��,Y7�l�5� ��I��.���wqU��;���Q�Z��[�LI\�uXL��:��Y�b���C�����s�f~�Mz6�9�{͸��C�5������ݧ��C��.$;g�_�ˍ�	�����ŴV%�	��[/=	ӄy�~�,�Z.�~66E����{j�2��ȍcz���_���^���Iһ������վg�$ޕjd~miMҢ�&�07�ǡp��%����v�u���io�|[�ş��r_*=d�-����ʅ�h��)����+�Xy�S���[_�ܒ�E��j��歵��?v�⸽t�wqQ��6#t�0����k.Gݞ��i��?�)�m�6�a�N� ����E����	�G<dG���c6��
+|<7��=�ģ�xU�Q�|z�������qS�u�HAE�����i��c��?��.�u�{�%\���~ɰ�V&oX���lP7��q}s����a|E:%G�M�y�"VQ6�n��^���.VS�~r�f䋜�+()�xm�x�L�l����w\�CH�<c��3�t�Ѩi�H�:[�|U�t��"8�q_�bL���VKs�c�&C������!�Ɍ���&��|ӊ���9����>Ejb"#�b��^�~�S�zT����	�S�z�˕U����r�����.j�:r�͵�!�j�#�ޏ�f�̗s�UԪ�J{����Cz>7�N�~���`R��VH	�����K=��}��)����Zݤ;c�I��w���Ж��P�Z]�}9tZW���E�c%��o`E�"�o��>~�6�m��ͳeZ���I�/xH�a�O��Y�5�f����mP�BM��%�{!��J�6嘫ש�O(�X�ɛ`J�ֻ�Գ�n�C��c<i�Z:����f(ڢ[�:���C��k<c[G*Ux��\�P��Q��b�}@����瓸��vJf�^Ǣy�g�D�e�u��|Y��ϋy�X�/HP��D��ny�Iw������)w��K6�G���2�(��>tpqQ�Jw^�3*���������}��	�Wc�Mm~�f(U���i�Xk�5MS��XUv3Ԋ��%��p=�m0���{�U�1�i�ܞL�Up7m=Y�A{�����T ��¦M��|ӡ:�.ٛ?Q�"G�(A�Ge'���E����f��[֙���Ц�|���!��}��>_�&�ː�����\�\���__b�{�����Q�׊#\��<o�r���2�e?E��Ag}��,�`�o��k�15�鎱CEN�-�Y:�X�Њ��Nk(�h�*Ϝ���I%^�[�>̥�~�ųv�}Ac�F�ɘ��^l���7��[�!������n�v��TvN�+��4��F����er:��٫�t�;!��$�E_��E=4��=��n��TT'ks���@�O�f�Q{א����cm�`�sn�`]M?T@<��b�\����d��K�|���9����6��^3��
��훴��XkO/�����tS�fpJ�[%[�k����$����"F���5�K����ƙ_��(��I~((�@����3���O����75L��U�"��G���#�������{�8�l����]�@q��1���3���Q�9e��_4�d�1��cԆd�k�hb$�l�=�׮3��}�qsw̳l�Lw�n�{���+���Nm+G؛��g�]i�pV^�7�b_|d#�]�S������4����{g��5��$�$��	�~>�ڨHyW��~��E�CBM���כ�:�G��MG�m�� ,�A�\�,X�|W�;���>��s�kc@ك�4�}�6�g��>����S�ԗ�B��K���ĺw�Ƒt�J�0~i�׍>ȯmp~�c)\UYml<�#hu�|pI~>�{X��Ug�m���Pip����%t�S:O�?N���I|zb�=[�ƣ�93�7i�P�t�+���MhB���;.�����S���|'�Zλ�d˒��|���%��䙨l߿�޸&'�[3,��ؾ��s:���۰W�O�1���/R�eB��)O	�o�r��K�uv����QW����,fn�[c�ݧx&�O��Lf�&����I+�l��qR�(v���z��e>�lrN��ラ��/�ʄ�������75J՟�
���Q�UU_��Q^��E���}"A6筘~�=O�����o�V��K�4�]Q���'��r�논g��fW��K���T�JM�J���V�ɿ����ɽh&;�$��)P�������ڇsC�����k��/ş��av�g���v�<����{�Tc��w�f����`h��OS�U��q<�^��}��|1� ��M����̉rm���_4��_LK���,��u�����#O�R�u_��6�N�i��/����4ߩ�����x���r}~h�U�o<�j���@���{M�j`3c�pė����b/}L��-hjγ,Y�X���UiM������v��V&��q��X_��?ZQ��i�n/l��hL;���(Rוi�+ՃՅ��*7���
�X��_P�q��ҩ��r�/m��q����8�0���{�q�9�]j�*L��:������C�ɦ�߹ݪZA<:��[Ns�Q*�ck�+@cn�w�Up���i���Ε9?�]i��>,?beƁ�R��"��ɖ���7|pE��s�k�l���/���k]��C��<�BU���kVG��=�ޖ�[L���=}���S1�z	�
[�ӷ���U�pW�I�{RUas���)�XQ��>d�%��WV����r�L>�M��6s���Q�@����Kcl�3� �I���Hm}������Y��W���w����E9�;`<D�0V�L����3|K�w�*��"o�Ayty\)��Q�YrFj��'z��c�_���x���BY�9��d3e������$b�nvTU&iV\�^
Q����lp,}�u	뻚�q-*��e��q* '44��f���h�������1,'&!'*.%�C!Q??�/��"��D;�zCD=��N�j��"h;g<���/j�rwA9B�����D�1��/�GѾ8I����1c�|���@E|���������@;�� P�r�C�AD�\l���y8ٸ8���p�6v��v�8B(��� $���~~Q/'O�����4�3 ��	{��u>�p1�zl��׻�&����G��M��{)�7��/�=�<�JA�>�A�/���O8�A���ةv������5���:B�s����b�	�/Tu��$��%�l�'�� PCȿ�O�\�uJ��	�.�Q���x{�]�W���|�؇�{N|އ@�����e?N�7������D��������jM�eO��
���	��]���M��������`����?ẹ�~����W��wُs�MI�s�5��YI!��/�W��������{���������'��������y/����^��������]�v�7�ϋt�������5���~
_��.�`/���OL��
o��X?���sE  
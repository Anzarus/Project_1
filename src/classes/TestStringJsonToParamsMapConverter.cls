/**
 * Created by AntonAntoniuk on 23.08.2019.
 */

@IsTest
private class TestStringJsonToParamsMapConverter {
    @IsTest
    static void severalArgumentsTest() {
        String str = '{"oppId":"0062o00000y4LuJAAU","prodId":"01t2o000009eHJ6AAM"}';

        Map<String, String> params = StringJsonToParamsMapConverter.convertJsonToParamsMap(str);

        Map<String, String> expected = new Map<String, String>();
        expected.put('oppId', '0062o00000y4LuJAAU');
        expected.put('prodId', '01t2o000009eHJ6AAM');

        System.assertEquals(expected, params);
    }

    @IsTest
    static void singleArgumentTest() {
        String str = '{"oppId":"0062o00000y4LuJAAU"}';

        Map<String, String> params = StringJsonToParamsMapConverter.convertJsonToParamsMap(str);

        Map<String, String> expected = new Map<String, String>();
        expected.put('oppId', '0062o00000y4LuJAAU');

        System.assertEquals(expected, params);
    }
}
/**
 * Created by AntonAntoniuk on 23.08.2019.
 */

public with sharing class StringJsonToParamsMapConverter {

    public static Map<String, String> convertJsonToParamsMap(String json) {
        return new stringToMapParser().parseStrToMap(json);
    }

    private class stringToMapParser {

        private Map<String, String> parseStrToMap(String json) {

            Map<String, String> parameters = new Map<String, String>();

            String key;
            String value;
            for(String param : json.split(',')){
                key = param.substringBetween('"','":');
                value = param.substringBetween(':"','"');
                parameters.put(key, value);
            }
            return parameters;
        }
    }
}
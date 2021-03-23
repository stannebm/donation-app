import { FormControl } from "@chakra-ui/form-control";
import { FormErrorMessage, Select } from "@chakra-ui/react";
import React from "react";
import type { FieldErrors } from "react-hook-form/dist/types";
import * as R from "ramda";

export type FormSelectType = {
  name: string;
  label: string;
  options: string[];
  errors?: FieldErrors;
  styles?: {
    [k: string]: any;
  };
  [rest: string]: any;
};

const FormSelect = React.forwardRef<any, FormSelectType>((props, ref) => {
  const { name, label, options, errors, styles, ...rest } = props;
  let { errorPath } = props;

  if (errorPath === undefined) {
    errorPath = R.path([name]);
  }

  return (
    <FormControl isInvalid={!!errorPath!(errors)} {...styles}>
      <Select name={name} placeholder={`- ${label} -`} ref={ref} {...rest}>
        {options.map((option) => (
          <option value={option} key={option}>
            {option}
          </option>
        ))}
      </Select>
      <FormErrorMessage>{errorPath!(errors)?.message}</FormErrorMessage>
    </FormControl>
  );
});

export default FormSelect;

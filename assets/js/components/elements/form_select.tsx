import { FormControl } from "@chakra-ui/form-control";
import { FormErrorMessage, Select } from "@chakra-ui/react";
import React from "react";
import type { FieldErrors } from "react-hook-form/dist/types";

export type FormSelectType = {
  name: string;
  label: string;
  options: string[];
  errors: FieldErrors;
  [rest: string]: any;
};

const FormSelect = React.forwardRef<any, FormSelectType>((props, ref) => {
  const {
    name,
    label,
    options,
    errors,
    ...rest
  } = props
  return (
    <FormControl isInvalid={errors[name]} {...rest}>
      <Select name={name} placeholder={label} ref={ref}>
        {options.map((option) => (
          <option value={option} key={option}>
            {option}
          </option>
        ))}
      </Select>
      <FormErrorMessage>{errors.name && errors.name.message}</FormErrorMessage>
    </FormControl>
  );
})

export default FormSelect;

import { FormControl } from "@chakra-ui/form-control";
import { FormErrorMessage, Input } from "@chakra-ui/react";
import React from "react";
import type { FieldErrors } from "react-hook-form/dist/types";

export type FormInputType = {
  name: string;
  label: string;
  errors: FieldErrors;
  styles?: {
    [k: string]: any;
  };
  [rest: string]: any;
};

const FormInput = React.forwardRef<any, FormInputType>((props, ref) => {
  const { name, label, errors, styles, ...rest } = props;
  return (
    <FormControl isInvalid={errors?.[name]} {...styles}>
      <Input
        bgColor="white"
        name={name}
        placeholder={label}
        ref={ref}
        {...rest}
      />
      <FormErrorMessage>{errors?.[name]?.message}</FormErrorMessage>
    </FormControl>
  );
});

export default FormInput;

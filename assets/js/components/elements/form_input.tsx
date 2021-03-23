import { FormControl } from "@chakra-ui/form-control";
import { FormErrorMessage, Input, Tooltip } from "@chakra-ui/react";
import * as R from "ramda";
import React from "react";
import type { FieldErrors } from "react-hook-form/dist/types";

export type FormInputType = {
  name: string;
  label: string;
  errors: FieldErrors;
  errorPath?: (errors: FieldErrors) => any;
  styles?: {
    [k: string]: any;
  };
  [rest: string]: any;
};

const FormInput = React.forwardRef<any, FormInputType>((props, ref) => {
  const { name, label, errors, styles, ...rest } = props;
  let { errorPath } = props;

  if (errorPath === undefined) {
    errorPath = R.path([name]);
  }

  return (
    <Tooltip label={label} placement="top-start">
      <FormControl isInvalid={!!errorPath!(errors)} {...styles}>
        <Input
          bgColor="white"
          name={name}
          placeholder={label}
          ref={ref}
          {...rest}
        />
        <FormErrorMessage>{errorPath!(errors)?.message}</FormErrorMessage>
      </FormControl>
    </Tooltip>
  );
});

export default FormInput;
